# Gateway - Pocket Network Shannon Testnet Node & Gateway

A comprehensive setup for running a Pocket Network Shannon testnet node with an integrated gateway service using Docker Compose.

## 🚀 Overview

This repository contains the configuration and scripts needed to run:
- **Shannon Testnet Node**: A Pocket Network full node running on the Shannon testnet
- **Gateway Service**: A Path gateway service for routing requests to the Pocket Network

## 📁 Project Structure

```
gateway/
├── apps/                    # Web application components
│   └── web/
├── gateway/                 # Gateway configuration
│   └── config/
├── pocket-testnet/          # Pocket Network testnet data and config
├── scripts/                 # Node startup and management scripts
│   ├── start-fullnode.sh   # Main node startup script
│   └── full-node.sh        # Full node management script
├── docker-compose.yaml      # Docker services configuration
├── .env                     # Environment variables (not tracked)
└── .gitignore              # Git ignore rules
```

## 🛠️ Prerequisites

- Docker and Docker Compose
- Git
- Linux/Unix environment
- At least 4GB RAM and 100GB storage for the node

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/infoboy27/gateway.git
cd gateway
```

### 2. Environment Setup

Create a `.env` file with your configuration:

```bash
cp .env.example .env
# Edit .env with your specific values
```

### 3. Start the Services

```bash
docker-compose up -d
```

### 4. Monitor the Services

```bash
# View logs
docker-compose logs -f

# Check service status
docker-compose ps
```

## 🔧 Configuration

### Node Configuration

The Shannon testnet node runs with the following configuration:
- **Chain ID**: `pocket-testnet`
- **Genesis URL**: `https://shannon-testnet-grove-rpc.beta.poktroll.com/genesis`
- **Ports**:
  - `26656`: P2P networking
  - `26657`: RPC endpoint
  - `9090`: gRPC endpoint

### Gateway Configuration

The Path gateway service:
- Runs on port `3069`
- Uses configuration from `gateway/config/.config.yaml`
- Automatically connects to the running node

## 📊 Monitoring & Health Checks

The services include built-in health checks:
- **Node Health Check**: Monitors RPC endpoint availability
- **Logging**: JSON-formatted logs with rotation (10MB max, 3 files)
- **Auto-restart**: Services restart automatically unless stopped manually

## 🔍 Scripts

### `start-fullnode.sh`

Main startup script that:
- Downloads and validates genesis.json
- Initializes Pocket Network configuration files
- Sanitizes corrupted TOML files
- Configures persistent peers and seeds
- Ensures public port binding
- Starts the pocketd daemon

### `full-node.sh`

Comprehensive node management script with additional features.

## 🌐 Network Configuration

The services run on a custom Docker network called `shannon` for isolation and security.

## 📝 Logs

View logs for specific services:

```bash
# Node logs
docker-compose logs shannon-testnet-node

# Gateway logs
docker-compose logs shannon-testnet-gateway

# Follow logs in real-time
docker-compose logs -f shannon-testnet-node
```

## 🛑 Stopping Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: This will delete node data)
docker-compose down -v
```

## 🔄 Updating

To update the services:

```bash
# Pull latest images
docker-compose pull

# Restart services
docker-compose up -d
```

## 🐛 Troubleshooting

### Common Issues

1. **Permission Denied**: Ensure the scripts directory has proper permissions
2. **Port Conflicts**: Check if ports 26656, 26657, 9090, or 3069 are already in use
3. **Genesis Download Issues**: Verify network connectivity and genesis URL accessibility

### Debug Mode

Enable verbose logging:

```bash
docker-compose up -d --verbose
```

## 📚 Additional Resources

- [Pocket Network Documentation](https://docs.pokt.network/)
- [Shannon Testnet Information](https://shannon-testnet.nodes.pokt.network/)
- [Path Gateway Documentation](https://github.com/buildwithgrove/path)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🆘 Support

For issues and questions:
- Create an issue in this repository
- Check the troubleshooting section above
- Review the Pocket Network documentation

---

**Note**: This setup is configured for the Shannon testnet. For mainnet deployment, additional security measures and configuration changes are required.
