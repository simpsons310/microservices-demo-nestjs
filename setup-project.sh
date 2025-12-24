#!/bin/bash

# ============================================
# Auto Setup Script for Microservices Project
# Save as: setup-project.sh
# Usage: chmod +x setup-project.sh && ./setup-project.sh
# ============================================

set -e

echo "🚀 Setting up Microservices E-commerce Project"
echo "=============================================="
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Project name
# PROJECT_NAME="microservices-ecommerce"

# echo -e "${YELLOW}Step 1: Creating project structure${NC}"
# mkdir -p $PROJECT_NAME
# cd $PROJECT_NAME

# Create service directories
mkdir -p api-gateway/src/auth
mkdir -p api-gateway/src/proxy

mkdir -p user-service/src/user/dto
mkdir -p user-service/src/auth/dto

mkdir -p product-service/src/product/dto

mkdir -p order-service/src/order/dto
mkdir -p order-service/src/clients

echo -e "${GREEN}✓ Project structure created${NC}"
echo ""

# Create nest-cli.json for all services
echo -e "${YELLOW}Step 2: Creating nest-cli.json files${NC}"
for service in api-gateway user-service product-service order-service; do
  cat > $service/nest-cli.json << 'EOF'
{
  "collection": "@nestjs/schematics",
  "sourceRoot": "src"
}
EOF
done
echo -e "${GREEN}✓ nest-cli.json files created${NC}"
echo ""

# Create .gitignore
echo -e "${YELLOW}Step 3: Creating .gitignore${NC}"
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
package-lock.json
yarn.lock

# Environment
.env
.env.local

# Build
dist/
build/

# Logs
*.log
logs/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Docker
.docker/
EOF
echo -e "${GREEN}✓ .gitignore created${NC}"
echo ""

# Create .dockerignore for each service
echo -e "${YELLOW}Step 4: Creating .dockerignore files${NC}"
for service in api-gateway user-service product-service order-service; do
  cat > $service/.dockerignore << 'EOF'
node_modules
npm-debug.log
dist
.git
.gitignore
README.md
.env
.vscode
EOF
done
echo -e "${GREEN}✓ .dockerignore files created${NC}"
echo ""

# Create README.md
echo -e "${YELLOW}Step 5: Creating README.md${NC}"
cat > README.md << 'EOF'
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
```

## Documentation

See the documentation artifacts for complete details on:
- Architecture design
- API endpoints
- Setup instructions
- Testing guide

## Services

- API Gateway: http://localhost:3000
- User Service: http://localhost:3001
- Product Service: http://localhost:3002
- Order Service: http://localhost:3003

## Tech Stack

- NestJS (TypeScript)
- PostgreSQL
- Redis
- Docker
- TypeORM
- JWT Authentication

## License

MIT
EOF
echo -e "${GREEN}✓ README.md created${NC}"
echo ""

echo "=============================================="
echo -e "${GREEN}✓ Project setup completed!${NC}"
echo "=============================================="
echo ""
echo "Next steps:"
echo "1. Copy code from artifacts to respective files"
echo "2. Copy docker-compose.yml to root directory"
echo "3. Copy .env.example to .env"
echo "4. Run: docker-compose up --build"
echo ""
echo "Project structure:"
echo ""
tree -L 2 -I 'node_modules' . 2>/dev/null || find . -maxdepth 2 -not -path '*/\.*' -print
echo ""
echo "Happy coding! 🎉"
