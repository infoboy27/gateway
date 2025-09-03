# Path Gateway Setup Guide

This guide will help you set up and run the Path Gateway with your Shannon testnet node, following the [Grove Path documentation](https://path.grove.city/develop/path/getting_started).

## 🚀 Quick Start

### 1. Prerequisites

- Docker and Docker Compose installed
- Shannon testnet node running (already configured in this repo)
- Pocket Network CLI tools (optional, for testing)

### 2. Configuration Files

The setup includes two main configuration files:

#### `.config.yaml` - Main Configuration
- **Node Connection**: Points to local Shannon testnet node
- **Gateway Mode**: Centralized mode for testing
- **Network Settings**: Local RPC and gRPC endpoints
- **CORS**: Enabled for web applications

#### `.values.yaml` - Authentication (Not committed to git)
- **Gateway Private Key**: Your gateway's private key
- **App Private Keys**: Private keys for your applications
- **Environment Variables**: Additional configuration

### 3. Start the Services

```bash
# Start both Shannon node and Path gateway
docker-compose up -d

# Check service status
docker-compose ps

# View logs
docker-compose logs -f shannon-testnet-gateway
```

### 4. Verify the Setup

#### Check Node Health
```bash
# Check Shannon node
curl http://localhost:26657/status

# Check Path gateway
curl http://localhost:3069/health
```

#### Test Path Gateway
```bash
# Test basic connectivity
curl http://localhost:3069/status

# Test with a simple relay request
curl -X POST http://localhost:3069/v1/client/send \
  -H "Content-Type: application/json" \
  -d '{
    "relay_network": "shannon",
    "payload": {
      "data": "test",
      "method": "GET",
      "path": "/",
      "headers": {}
    }
  }'
```

## 🔧 Configuration Details

### Node Connection
- **RPC URL**: `http://shannon-testnet-node:26657` (internal Docker network)
- **gRPC**: `shannon-testnet-node:9090` (internal Docker network)
- **Insecure**: `true` (local connection, no TLS needed)

### Gateway Settings
- **Mode**: Centralized (gateway signs and uses your apps)
- **Port**: 3069 (HTTP API)
- **CORS**: Enabled for all origins (development)

### Health Checks
- **Node**: Checks RPC endpoint availability
- **Gateway**: Checks HTTP health endpoint
- **Dependencies**: Gateway waits for node to be healthy

## 🧪 Testing Your Setup

### 1. Basic Connectivity Test
```bash
# Test if the gateway is responding
curl -v http://localhost:3069/health
```

### 2. Relay Test
```bash
# Send a test relay through your gateway
curl -X POST http://localhost:3069/v1/client/send \
  -H "Content-Type: application/json" \
  -d '{
    "relay_network": "shannon",
    "payload": {
      "data": "",
      "method": "GET",
      "path": "/",
      "headers": {}
    }
  }'
```

### 3. Monitor Logs
```bash
# Watch gateway logs
docker-compose logs -f shannon-testnet-gateway

# Watch node logs
docker-compose logs -f shannon-testnet-node
```

## 🐛 Troubleshooting

### Common Issues

1. **Gateway won't start**
   - Check if Shannon node is healthy: `docker-compose ps`
   - Verify configuration files exist and are valid
   - Check logs: `docker-compose logs shannon-testnet-gateway`

2. **Connection refused**
   - Ensure both services are running: `docker-compose ps`
   - Check network connectivity between containers
   - Verify ports are not blocked by firewall

3. **Authentication errors**
   - Verify `.values.yaml` contains correct private keys
   - Check if keys match the ones in `.config.yaml`
   - Ensure keys are in correct hex format

### Debug Mode

Enable verbose logging:
```bash
# Update .config.yaml
logger_config:
  level: "debug"

# Restart services
docker-compose restart shannon-testnet-gateway
```

## 📚 Next Steps

1. **Test with real applications**: Try connecting your dApp to the gateway
2. **Monitor performance**: Use the health endpoints to track service status
3. **Scale up**: Add more app private keys for multiple applications
4. **Production setup**: Modify configuration for production deployment

## 🔗 Useful Resources

- [Path Documentation](https://path.grove.city/)
- [Pocket Network Guide](https://path.grove.city/develop/path/pocket_network_guide)
- [Path Configurations](https://path.grove.city/develop/path/configurations)
- [Troubleshooting Guide](https://path.grove.city/develop/path/troubleshooting)

## 📝 Notes

- This setup is configured for **development/testing** on Shannon testnet
- For production, consider:
  - Using secure private keys (not the example ones)
  - Enabling TLS for external connections
  - Implementing proper authentication
  - Setting up monitoring and alerting
  - Using environment variables for sensitive data

---

Your Path Gateway is now ready to route requests through your Shannon testnet node! 🎉
