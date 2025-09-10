# Gateway - Pocket Network Shannon Testnet Node & Gateway

A comprehensive production-ready setup for running a Pocket Network Shannon testnet node with integrated gateway service, monitoring, and web applications using Docker Compose.

## 🚀 Overview

This repository provides a complete solution for running:

* **Shannon Testnet Node**: A Pocket Network full node running on the Shannon testnet (v0.1.29)
* **Gateway Service**: A Path gateway service for routing requests to the Pocket Network
* **Web Dashboard**: Real-time monitoring dashboard built with Next.js
* **Documentation Site**: Comprehensive documentation using Docusaurus
* **Monitoring Stack**: Prometheus and Grafana for metrics and visualization

## 📁 Project Structure

```
gateway/
├── apps/                           # Web applications
│   └── web/                       # Next.js dashboard application
│       ├── app/                   # Next.js app directory
│       ├── components/            # React components
│       ├── package.json           # Node.js dependencies
│       ├── next.config.js         # Next.js configuration
│       ├── tailwind.config.js     # Tailwind CSS configuration
│       └── tsconfig.json          # TypeScript configuration
├── gateway/                       # Gateway configuration
│   └── config/
│       └── .config.yaml          # Path gateway configuration
├── pathold/                       # Legacy documentation
│   └── docusaurus/               # Docusaurus documentation site
├── prometheus/                    # Monitoring configuration
│   └── prometheus.yml            # Prometheus metrics configuration
├── pocket-testnet/               # Pocket Network testnet data and config
├── scripts/                      # Node startup and management scripts
│   ├── start-fullnode.sh        # Main node startup script
│   └── full-node.sh             # Full node management script
├── temp-docker-build/            # Custom Docker image build
│   └── Dockerfile               # Custom node image with correct binary
├── docker-compose.yaml          # Development Docker services
├── docker-compose.prod.yaml     # Production Docker services
├── README.md                    # This file
├── README-PRODUCTION.md         # Production setup guide
├── PATH_SETUP.md               # Path gateway setup guide
└── .env                        # Environment variables (not tracked)
```

## 🛠️ Prerequisites

* Docker and Docker Compose
* Git
* Linux/Unix environment
* At least 4GB RAM and 100GB storage for the node
* Node.js 18+ (for local development)

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/infoboy27/gateway.git
cd gateway
```

### 2. Environment Setup

Create a `.env` file with your configuration:

```bash
# Onchain actors credentials
APPLICATION_PRIV_KEY_HEX=""
APPLICATION_ADDR=""

SUPPLIER_MNEMONIC="your-supplier-mnemonic"
SUPPLIER_ADDR="your-supplier-address"

GATEWAY_PRIV_KEY_HEX="your-gateway-private-key"
GATEWAY_ADDR="your-gateway-address"
```

### 3. Start the Services

#### Development Mode
```bash
# Start core services (node only)
docker-compose up -d

# Check status
docker-compose ps
```

#### Production Mode
```bash
# Start complete production stack
docker-compose -f docker-compose.prod.yaml up -d

# Check status
docker-compose -f docker-compose.prod.yaml ps
```

### 4. Access the Services

| Service | URL | Description |
|---------|-----|-------------|
| **📊 Dashboard** | http://localhost:3002 | Real-time node monitoring |
| **📚 Documentation** | http://localhost:3000 | Comprehensive guides |
| **📈 Grafana** | http://localhost:3001 | Metrics visualization (admin/admin) |
| **🔍 Prometheus** | http://localhost:9091 | Metrics collection |
| **🔗 Node RPC** | http://localhost:26657 | Pocket Network RPC |
| **🔗 Node gRPC** | http://localhost:9090 | Pocket Network gRPC |

## 🔧 Configuration

### Node Configuration

The Shannon testnet node runs with the following configuration:

* **Chain ID**: `pocket-testnet`
* **Genesis URL**: `https://shannon-testnet-grove-rpc.beta.poktroll.com/genesis`
* **Version**: `v0.1.29` (custom fixed image)
* **Ports**:  
   * `26656`: P2P networking  
   * `26657`: RPC endpoint  
   * `9090`: gRPC endpoint

### Gateway Configuration

The Path gateway service:

* Runs on port `3069`
* Uses configuration from `gateway/config/.config.yaml`
* Automatically connects to the running node
* Supports both centralized and decentralized modes

### Web Applications

#### Dashboard (Next.js)
* **Framework**: Next.js 14 with TypeScript
* **Styling**: Tailwind CSS
* **Data Fetching**: TanStack Query
* **Features**: Real-time node status, health monitoring, metrics display

#### Documentation (Docusaurus)
* **Framework**: Docusaurus
* **Content**: Comprehensive guides and API documentation
* **Features**: Search, navigation, responsive design

## 📊 Monitoring & Health Checks

### Built-in Health Checks

* **Node Health Check**: Monitors RPC endpoint availability
* **Gateway Health Check**: Monitors gateway service status
* **Web App Health Checks**: Monitors application availability
* **Logging**: JSON-formatted logs with rotation (10MB max, 3 files)
* **Auto-restart**: Services restart automatically unless stopped manually

### Prometheus Metrics

* Node metrics: `http://localhost:26657/metrics`
* System metrics: Available through node-exporter
* Custom metrics: Configured in `prometheus/prometheus.yml`

### Grafana Dashboards

Access Grafana at `http://localhost:3001` and create dashboards for:
* Node health and sync status
* System resource usage
* Network connectivity
* Custom application metrics

## 🔍 Scripts

### `start-fullnode.sh`

Main startup script that:

* Downloads and validates genesis.json
* Initializes Pocket Network configuration files
* Sanitizes corrupted TOML files
* Configures persistent peers and seeds
* Ensures public port binding
* Starts the pocketd daemon with correct version

### `full-node.sh`

Comprehensive node management script with additional features.

## 🌐 Network Configuration

The services run on a custom Docker network called `shannon` for isolation and security.

## 📝 Logs

View logs for specific services:

```bash
# Node logs
docker-compose logs shannon-testnet-node

# Gateway logs (when enabled)
docker-compose logs shannon-testnet-gateway

# Web application logs
docker-compose logs gateway-dashboard
docker-compose logs path-docs

# Follow logs in real-time
docker-compose logs -f shannon-testnet-node
```

## 🛑 Stopping Services

```bash
# Stop all services
docker-compose down

# Stop production services
docker-compose -f docker-compose.prod.yaml down

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

1. **Node Upgrade Required**: The node requires v0.1.29. Use the custom `shannon-fixed:v0.1.29` image.
2. **Gateway Private Key Issues**: Gateway service may require proper private key configuration.
3. **Port Conflicts**: Check if required ports are already in use.
4. **Permission Denied**: Ensure the scripts directory has proper permissions.
5. **Genesis Download Issues**: Verify network connectivity and genesis URL accessibility.

### Debug Mode

Enable verbose logging:

```bash
docker-compose up -d --verbose
```

### Health Check Commands

```bash
# Check node health
curl http://localhost:26657/status

# Check gateway health (when enabled)
curl http://localhost:3069/health

# Check web applications
curl http://localhost:3000  # Documentation
curl http://localhost:3002  # Dashboard
```

## 🚀 Production Deployment

For production deployment, see [README-PRODUCTION.md](README-PRODUCTION.md) for detailed instructions including:

* Production Docker Compose configuration
* Monitoring setup
* Security considerations
* Backup procedures
* Maintenance tasks

## 🔒 Security Considerations

1. **Firewall**: Configure firewall rules to restrict access to necessary ports
2. **Authentication**: Implement authentication for Grafana and other services
3. **HTTPS**: Use reverse proxy with SSL certificates for production
4. **Private Keys**: Store private keys securely and never commit them to version control
5. **Network Isolation**: Use Docker networks for service isolation

## 📚 Additional Resources

* [Pocket Network Documentation](https://docs.pokt.network/)
* [Shannon Testnet Information](https://docs.pokt.network/home/resources/references/testnet)
* [Path Gateway Documentation](https://github.com/buildwithgrove/path)
* [Next.js Documentation](https://nextjs.org/docs)
* [Docusaurus Documentation](https://docusaurus.io/docs)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available under the MIT License.

## 🆘 Support

For issues and questions:

* Create an issue in this repository
* Check the troubleshooting section above
* Review the Pocket Network documentation
* Check the production setup guide

## 🎯 Features Implemented

### ✅ Core Functionality
- [x] Shannon testnet node with v0.1.29
- [x] Custom Docker image with correct binary
- [x] Path gateway service configuration
- [x] Health checks and monitoring
- [x] Automatic restarts and error recovery

### ✅ Web Applications
- [x] Next.js dashboard with real-time monitoring
- [x] Docusaurus documentation site
- [x] Responsive design with Tailwind CSS
- [x] TypeScript support
- [x] TanStack Query for data fetching

### ✅ Production Features
- [x] Production Docker Compose setup
- [x] Prometheus metrics collection
- [x] Grafana visualization
- [x] Log management with rotation
- [x] Volume persistence
- [x] Network isolation
- [x] Comprehensive documentation

### ✅ Monitoring & Observability
- [x] Health checks for all services
- [x] Prometheus metrics endpoint
- [x] Grafana dashboards
- [x] Structured logging
- [x] Service status monitoring

---

**Note**: This setup is configured for the Shannon testnet. For mainnet deployment, additional security measures and configuration changes are required.

---

_Last updated: September 10, 2025_