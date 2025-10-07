# HBase Docker Cluster

A production-ready HBase cluster running in Docker containers with ZooKeeper ensemble for high availability and fault tolerance.

## 🏗️ Architecture Overview

This cluster consists of:

- **3-node ZooKeeper ensemble** (zookeeper-1, zookeeper-2, zookeeper-3)
- **1 HBase Master** for cluster coordination and metadata management
- **1 HBase RegionServer** for data storage and query processing
- **Custom Docker network** with static IP addressing

## 🚀 Quick Start

### Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Make (optional, for convenience commands)
- At least 4GB RAM available for containers

### Starting the Cluster

```bash
# Using Docker Compose directly
docker compose up -d

# Or using the provided Makefile
make up
```

### Verifying the Cluster

```bash
# Check container status
docker compose ps

# Or using Makefile
make status

# View logs
make logs
```

## 📊 Service Details

### ZooKeeper Ensemble

| Service | Container | Host Port | Internal IP | Purpose |
|---------|-----------|-----------|-------------|---------|
| zookeeper-1 | zookeeper-1 | 2181 | 172.16.0.10 | Primary coordinator |
| zookeeper-2 | zookeeper-2 | 2182 | 172.16.0.11 | Secondary coordinator |
| zookeeper-3 | zookeeper-3 | 2183 | 172.16.0.12 | Tertiary coordinator |

### HBase Services

| Service | Container | Host Ports | Internal IP | Purpose |
|---------|-----------|------------|-------------|---------|
| hbase-master | hbase-master | 16000, 16010 | 172.16.0.13 | Cluster management |
| hbase-regionserver | hbase-regionserver | 16020, 16030 | 172.16.0.14 | Data processing |

## 🔧 Configuration

### Key Configuration Parameters

- **ZooKeeper Quorum**: `zookeeper-1,zookeeper-2,zookeeper-3`
- **ZooKeeper Port**: `2181` (internal)
- **HBase ZNode Parent**: `/hbase-unsecure`
- **HBase Master Heap**: `1024MB`
- **RegionServer Heap**: `2048MB`
- **Network Subnet**: `172.16.0.0/16`

### Environment Variables

The cluster uses the following key environment variables:

```yaml
# ZooKeeper Configuration
ZOO_MY_ID: 1, 2, 3  # Unique ID for each ZooKeeper node
ZOO_SERVERS: server.1=zookeeper-1:2888:3888;2181 server.2=zookeeper-2:2888:3888;2181 server.3=zookeeper-3:2888:3888;2181

# HBase Configuration
HBASE_MANAGES_ZK: false  # Use external ZooKeeper
HBASE_ZOOKEEPER_QUORUM: zookeeper-1,zookeeper-2,zookeeper-3
HBASE_ZOOKEEPER_PROPERTY_CLIENTPORT: 2181
HBASE_ZNODE_PARENT: /hbase-unsecure
```

## 🌐 Access Points

### Web UIs

- **HBase Master Web UI**: <http://localhost:16010>
- **HBase RegionServer Web UI**: <http://localhost:16020>

### API Endpoints

- **HBase Master RPC**: localhost:16000
- **HBase RegionServer RPC**: localhost:16020
- **HBase RegionServer Info**: localhost:16030

### ZooKeeper Access

- **ZooKeeper-1**: localhost:2181
- **ZooKeeper-2**: localhost:2182
- **ZooKeeper-3**: localhost:2183

## 🛠️ Management Commands

### Using Makefile

```bash
# Start all services
make up

# Stop all services
make down

# Restart all services
make restart

# View logs (follow mode)
make logs

# Check service status
make status

# Clean up (remove containers, volumes, and images)
make clean

# Show help
make help
```

### Using Docker Compose

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Restart services
docker compose restart

# View logs
docker compose logs -f

# Check status
docker compose ps

# Scale RegionServers (if needed)
docker compose up -d --scale hbase-regionserver=3
```

## 🔍 Monitoring and Troubleshooting

### Health Checks

```bash
# Check if HBase Master is running
curl -s http://localhost:16010/master-status

# Check ZooKeeper status
echo "stat" | nc localhost 2181

# Check RegionServer status
curl -s http://localhost:16020/rs-status
```

### Common Issues

1. **Port Conflicts**: Ensure ports 2181-2183, 16000, 16010, 16020, 16030 are available
2. **Memory Issues**: Ensure sufficient RAM (minimum 4GB recommended)
3. **Network Issues**: Check if Docker network `hbase-net` is created properly

### Logs

```bash
# View all logs
docker compose logs

# View specific service logs
docker compose logs hbase-master
docker compose logs hbase-regionserver
docker compose logs zookeeper-1
```

## 🔒 Security Considerations

- The cluster runs in **unsecure mode** (`/hbase-unsecure`)
- No authentication or authorization is configured
- Suitable for development and testing environments
- For production, consider implementing Kerberos authentication

## 📈 Scaling

### Horizontal Scaling

To add more RegionServers:

```bash
# Scale to 3 RegionServers
docker compose up -d --scale hbase-regionserver=3
```

### Vertical Scaling

Modify heap sizes in `docker-compose.yml`:

```yaml
environment:
  - HBASE_HEAPSIZE=4096  # Increase for more memory
```

## 🗂️ Data Persistence

- Data is stored in container filesystems
- For production, consider mounting volumes for data persistence
- ZooKeeper data is ephemeral by default

## 📚 Additional Resources

- [HBase Documentation](https://hbase.apache.org/book.html)
- [ZooKeeper Documentation](https://zookeeper.apache.org/doc/current/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Note**: This cluster is configured for development and testing purposes. For production deployments, additional security, monitoring, and persistence configurations should be implemented.
