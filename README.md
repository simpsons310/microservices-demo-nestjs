# 🚀 Microservices E-commerce Demo

A demo project showcasing microservices architecture using NestJS, TypeScript, and PostgreSQL.

## Architecture

- **API Gateway**: Entry point for all requests
- **User Service**: Authentication and user management
- **Product Service**: Product catalog management
- **Order Service**: Order processing

## Quick Start

```bash
# Start all services
docker-compose up --build

# Run tests
./test-api.sh

# For the first time, create database schema
./setup-db-schema.sh
# Restart apps
docker compose restart
```

## Documentation

See the documentation artifacts for complete details on:

- Architecture design
- API endpoints
- Setup instructions
- Testing guide

## Services

- API Gateway: <http://localhost:3000>
- User Service: <http://localhost:3001>
- Product Service: <http://localhost:3002>
- Order Service: <http://localhost:3003>

## Tech Stack

- NestJS (TypeScript)
- PostgreSQL
- Redis
- Docker
- TypeORM
- JWT Authentication

## License

MIT
