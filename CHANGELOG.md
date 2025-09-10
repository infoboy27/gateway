# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-09-10

### Added
- **Shannon Testnet Node**: Complete Pocket Network Shannon testnet node setup
- **Custom Docker Image**: Fixed v0.1.29 binary in custom `shannon-fixed:v0.1.29` image
- **Path Gateway Service**: Configuration for Path gateway with centralized/decentralized modes
- **Web Dashboard**: Next.js application with real-time node monitoring
- **Documentation Site**: Docusaurus-based comprehensive documentation
- **Production Setup**: Complete production-ready Docker Compose configuration
- **Monitoring Stack**: Prometheus and Grafana integration
- **Health Checks**: Comprehensive health monitoring for all services
- **Log Management**: JSON-formatted logs with rotation
- **Network Isolation**: Custom Docker network for security
- **Volume Persistence**: Data persistence for node and monitoring data

### Fixed
- **Node Upgrade Issue**: Resolved v0.1.28 to v0.1.29 upgrade requirement
- **Docker Image Mismatch**: Fixed incorrect binary version in official image
- **Gateway Configuration**: Improved gateway service configuration
- **Web Application Binding**: Fixed external access for web applications
- **Port Conflicts**: Resolved port binding issues

### Changed
- **Docker Compose**: Separated development and production configurations
- **Scripts**: Enhanced node startup and management scripts
- **Documentation**: Comprehensive README and production guides
- **Monitoring**: Integrated Prometheus and Grafana for observability

### Security
- **Network Isolation**: Services run on isolated Docker network
- **Health Checks**: Comprehensive service health monitoring
- **Log Rotation**: Automatic log rotation to prevent disk space issues
- **Volume Management**: Proper volume configuration for data persistence

## [0.1.0] - 2025-09-03

### Added
- Initial repository setup
- Basic Docker Compose configuration
- Shannon testnet node configuration
- Gateway service configuration
- Basic documentation

---

## Development Notes

### Known Issues
- Gateway service requires proper private key configuration for full functionality
- Some services may require manual restart after configuration changes

### Future Enhancements
- [ ] Automated backup procedures
- [ ] SSL/TLS configuration for production
- [ ] Advanced monitoring dashboards
- [ ] Automated testing suite
- [ ] CI/CD pipeline configuration
