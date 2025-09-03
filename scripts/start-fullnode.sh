#!/usr/bin/env bash
set -euo pipefail

HOME_DIR="/root/.pocket"
CFG_DIR="$HOME_DIR/config"
CHAIN_ID="${CHAIN_ID:-pocket-testnet}"
GENESIS_URL="${GENESIS_URL:-https://shannon-testnet.nodes.pokt.network/genesis.json}"

echo "[*] Home: $HOME_DIR  Chain-ID: $CHAIN_ID"

mkdir -p "$CFG_DIR" "$HOME_DIR/data"

# 1) genesis.json (validar que sea JSON real)
if [[ ! -s "$CFG_DIR/genesis.json" ]]; then
  echo "[*] Descargando genesis.json desde $GENESIS_URL"
  curl -fL --retry 5 --retry-delay 2 -o "$CFG_DIR/genesis.json" "$GENESIS_URL"
fi
if ! head -c 1 "$CFG_DIR/genesis.json" | grep -q "{" ; then
  echo "[!] genesis.json no parece JSON (¿HTML?). Borrando y abortando."
  rm -f "$CFG_DIR/genesis.json"
  exit 1
fi

# 2) Si faltan TOML, inicializa
need_init=0
for f in app.toml client.toml config.toml; do
  [[ -s "$CFG_DIR/$f" ]] || need_init=1
done

if [[ "$need_init" -eq 1 ]]; then
  echo "[*] Generando TOML por defecto con pocketd init"
  pocketd init "$(hostname)" --chain-id "$CHAIN_ID"
fi

# 3) Sanitizar: si algún TOML empieza con '<', se corrompió (HTML/merge); regenéralo
for f in app.toml client.toml config.toml; do
  if head -c 1 "$CFG_DIR/$f" 2>/dev/null | grep -q "<"; then
    echo "[!] $f corrupto (comienza con '<'). Regenerando..."
    mv "$CFG_DIR/$f" "$CFG_DIR/$f.bak.$(date +%s)" || true
    # Reinit parcial: borrar y reiniciar crea defaults
    rm -f "$CFG_DIR/$f"
    pocketd init "$(hostname)" --chain-id "$CHAIN_ID" >/dev/null
  fi
done

# 4) (Opcional) Seeds / Peers desde variables de entorno
#    PERSISTENT_PEERS="id@host:26656,..."
#    SEEDS="id@host:26656,..."
if [[ -n "${PERSISTENT_PEERS:-}" ]]; then
  sed -i 's|^persistent_peers *=.*|persistent_peers = "'"$PERSISTENT_PEERS"'"|' "$CFG_DIR/config.toml"
fi
if [[ -n "${SEEDS:-}" ]]; then
  sed -i 's|^seeds *=.*|seeds = "'"$SEEDS"'"|' "$CFG_DIR/config.toml"
fi

# 5) Asegurar puertos públicos
sed -i 's|^laddr *=.*26656.*|laddr = "tcp://0.0.0.0:26656"|' "$CFG_DIR/config.toml" || true
sed -i 's|^laddr *=.*26657.*|laddr = "tcp://0.0.0.0:26657"|' "$CFG_DIR/config.toml" || true

# 6) Arrancar
echo "[*] Iniciando pocketd..."
exec pocketd start --home "$HOME_DIR" --with-comet
