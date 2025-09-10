# Gateway Production Setup

This document describes how to run the complete Gateway stack in production mode.

## 🚀 Quick Start

### 1. Start All Services

```bash
# Start the complete production stack
docker-compose -f docker-compose.prod.yaml up -d

# Check status
docker-compose -f docker-compose.prod.yaml ps
```

### 2. Access the Services

- **📊 Dashboard**: http://your-server-ip:3002
- **📚 Documentation**: http://your-server-ip:3000
- **📈 Grafana**: http://your-server-ip:3001 (admin/admin)
- **🔍 Prometheus**: http://your-server-ip:9091
- **🔗 Node RPC**: http://your-server-ip:26657
- **🔗 Node gRPC**: http://your-server-ip:9090

## 📋 Services Overview

### Core Services

1. **Shannon Testnet Node** (`shannon-testnet-node`)
   - Pocket Network Shannon testnet node
   - Fixed v0.1.29 binary
   - Ports: 26656 (P2P), 26657 (RPC), 9090 (gRPC)

2. **Documentation Site** (`path-docs`)
   - Docusaurus-based documentation
   - Port: 3000

3. **Dashboard** (`gateway-dashboard`)
   - Next.js real-time monitoring dashboard
   - Port: 3002

### Monitoring Services

4. **Prometheus** (`prometheus`)
   - Metrics collection and storage
   - Port: 9091

5. **Grafana** (`grafana`)
   - Metrics visualization and dashboards
   - Port: 3001
   - Default login: admin/admin

## 🔧 Configuration

### Environment Variables

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

### Gateway Service

The gateway service is currently disabled due to private key configuration issues. To enable it:

1. Resolve the private key format issues
2. Uncomment the gateway service in `docker-compose.prod.yaml`
3. Restart the stack

## 📊 Monitoring

### Prometheus Metrics

- Node metrics: `http://your-server-ip:26657/metrics`
- System metrics: Available through node-exporter
- Custom metrics: Configured in `prometheus/prometheus.yml`

### Grafana Dashboards

Access Grafana at `http://your-server-ip:3001` and create dashboards for:
- Node health and sync status
- System resource usage
- Network connectivity
- Custom application metrics

## 🛠️ Maintenance

### Logs

```bash
# View all logs
docker-compose -f docker-compose.prod.yaml logs -f

# View specific service logs
docker-compose -f docker-compose.prod.yaml logs -f shannon-testnet-node
```

### Updates

```bash
# Pull latest images
docker-compose -f docker-compose.prod.yaml pull

# Restart services
docker-compose -f docker-compose.prod.yaml up -d
```

### Backup

```bash
# Backup node data
docker run --rm -v gateway_pocket-testnet:/data -v $(pwd):/backup alpine tar czf /backup/node-backup.tar.gz -C /data .

# Backup monitoring data
docker run --rm -v gateway_prometheus_data:/data -v $(pwd):/backup alpine tar czf /backup/prometheus-backup.tar.gz -C /data .
```

## 🔒 Security Considerations

1. **Firewall**: Configure firewall rules to restrict access to necessary ports
2. **Authentication**: Implement authentication for Grafana and other services
3. **HTTPS**: Use reverse proxy with SSL certificates for production
4. **Private Keys**: Store private keys securely and never commit them to version control

## 🐛 Troubleshooting

### Common Issues

1. **Node not syncing**: Check network connectivity and genesis file
2. **Services not accessible**: Verify firewall and port binding
3. **High resource usage**: Monitor system resources and adjust limits

### Health Checks

```bash
# Check node health
curl http://localhost:26657/status

# Check service health
docker-compose -f docker-compose.prod.yaml ps
```

## 📞 Support

For issues and questions:
- Check the documentation site: http://your-server-ip:3000
- Review logs: `docker-compose -f docker-compose.prod.yaml logs`
- Monitor metrics: http://your-server-ip:9091
