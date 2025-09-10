# PATH Gateway Setup Guide

This guide will help you set up and configure the PATH gateway service for the Pocket Network Shannon testnet.

## Prerequisites

- Docker and Docker Compose installed
- Access to the Shannon testnet node (v0.1.29)
- Valid gateway credentials
- Node.js 18+ (for web applications)

## Quick Start

### 1. Start the Complete Stack

```bash
# Development mode (node only)
docker-compose up -d

# Production mode (all services)
docker-compose -f docker-compose.prod.yaml up -d
```

### 2. Verify Services

```bash
# Check all services
docker-compose ps

# Check node health
curl http://localhost:26657/status

# Check gateway health (when enabled)
curl http://localhost:3069/health
```

### 3. Access Web Applications

- **Dashboard**: http://localhost:3002
- **Documentation**: http://localhost:3000
- **Grafana**: http://localhost:3001 (admin/admin)
- **Prometheus**: http://localhost:9091

## Configuration

### Gateway Configuration

The gateway configuration is located in `gateway/config/.config.yaml`. Key settings include:

```yaml
shannon_config:
  full_node_config:
    rpc_url: "http://shannon-testnet-node:26657"
    grpc_config:
      host_port: "shannon-testnet-node:9090"
      insecure: true
  gateway_config:
    gateway_mode: "centralized"  # or "decentralized"
    gateway_address: "your-gateway-address"
    gateway_private_key_hex: "your-private-key"
```

### Environment Variables

Create a `.env` file with your credentials:

```bash
# Gateway credentials
GATEWAY_PRIV_KEY_HEX="your-gateway-private-key"
GATEWAY_ADDR="your-gateway-address"

# Application credentials
APPLICATION_PRIV_KEY_HEX="your-application-private-key"
APPLICATION_ADDR="your-application-address"

# Supplier credentials
SUPPLIER_MNEMONIC="your-supplier-mnemonic"
SUPPLIER_ADDR="your-supplier-address"
```

## Services Overview

### Core Services

1. **Shannon Testnet Node** (`shannon-testnet-node`)
   - Pocket Network Shannon testnet node
   - Fixed v0.1.29 binary
   - Ports: 26656 (P2P), 26657 (RPC), 9090 (gRPC)

2. **Gateway Service** (`shannon-testnet-gateway`)
   - Path gateway for routing requests
   - Port: 3069
   - Currently disabled due to private key configuration issues

### Web Applications

3. **Dashboard** (`gateway-dashboard`)
   - Next.js real-time monitoring dashboard
   - Port: 3002
   - Features: Node status, health monitoring, metrics

4. **Documentation** (`path-docs`)
   - Docusaurus-based documentation site
   - Port: 3000
   - Features: Comprehensive guides and API docs

### Monitoring Services

5. **Prometheus** (`prometheus`)
   - Metrics collection and storage
   - Port: 9091

6. **Grafana** (`grafana`)
   - Metrics visualization and dashboards
   - Port: 3001
   - Default login: admin/admin

## Troubleshooting

### Common Issues

1. **Node Upgrade Required**: 
   - Error: `UPGRADE "v0.1.29" NEEDED at height: 306578`
   - Solution: Use the custom `shannon-fixed:v0.1.29` image

2. **Gateway Private Key Issues**:
   - Error: `invalid shannon gateway private key`
   - Solution: Verify private key format and configuration

3. **Port Conflicts**:
   - Error: `address already in use`
   - Solution: Stop conflicting services or change ports

4. **Web Applications Not Accessible**:
   - Issue: Services only accessible from localhost
   - Solution: Restart with `--host 0.0.0.0` flag

### Debug Commands

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f shannon-testnet-node
docker-compose logs -f shannon-testnet-gateway

# Check service health
docker-compose ps

# Test endpoints
curl http://localhost:26657/status
curl http://localhost:3069/health
curl http://localhost:3000
curl http://localhost:3002
```

### Health Checks

```bash
# Node health
curl -s http://localhost:26657/status | jq '.result.sync_info.latest_block_height'

# Gateway health (when enabled)
curl -s http://localhost:3069/health

# Web applications
curl -s http://localhost:3000 | grep -o '<title>.*</title>'
curl -s http://localhost:3002 | grep -o '<title>.*</title>'
```

## Testing

### Test the Gateway

```bash
# Run the test script
./test-path-gateway.sh

# Manual testing
curl -X POST http://localhost:3069/relay \
  -H "Content-Type: application/json" \
  -d '{"method": "eth_blockNumber", "params": [], "id": 1}'
```

### Test Web Applications

```bash
# Test documentation site
curl -s http://localhost:3000 | grep -o '<title>.*</title>'

# Test dashboard
curl -s http://localhost:3002 | grep -o '<title>.*</title>'
```

## Production Deployment

For production deployment, see [README-PRODUCTION.md](README-PRODUCTION.md) for detailed instructions.

## Security Considerations

1. **Private Keys**: Store securely and never commit to version control
2. **Network Access**: Configure firewall rules appropriately
3. **Authentication**: Implement authentication for monitoring services
4. **HTTPS**: Use SSL certificates for production deployments

## Support

For issues and questions:
- Check the troubleshooting section above
- Review the main [README.md](README.md)
- Create an issue in the repository
- Check Pocket Network documentation