# ✅ Setup Checklist - Microservices E-commerce

## 📋 Checklist Tổng Hợp

### Bước 1: Chuẩn bị môi trường

- [ ] Đã cài đặt Node.js 18+
- [ ] Đã cài đặt Docker Desktop
- [ ] Đã cài đặt Git
- [ ] Docker đang chạy (kiểm tra: `docker --version`)

### Bước 2: Tạo cấu trúc project

```bash
mkdir microservices-ecommerce
cd microservices-ecommerce
```

- [ ] Tạo thư mục `api-gateway`
- [ ] Tạo thư mục `user-service`
- [ ] Tạo thư mục `product-service`
- [ ] Tạo thư mục `order-service`

### Bước 3: Tạo docker-compose.yml

- [ ] Copy code từ artifact "docker-compose.yml"
- [ ] Save file tại root directory
- [ ] File đúng format YAML (check indentation)

### Bước 4: Tạo .env file

- [ ] Copy code từ artifact ".env.example"
- [ ] Save as `.env` tại root directory
- [ ] (Optional) Đổi passwords nếu muốn

---

## 🔧 Setup từng Service

### API Gateway (Port 3000)

#### Files cần tạo

```bash
api-gateway/
├── Dockerfile
├── package.json
├── tsconfig.json
├── nest-cli.json
└── src/
    ├── main.ts
    ├── app.module.ts
    ├── auth/
    │   ├── jwt.guard.ts
    │   └── auth.module.ts
    └── proxy/
        ├── proxy.controller.ts
        ├── proxy.service.ts
        └── proxy.module.ts
```

#### Checklist

- [ ] Tạo `api-gateway/Dockerfile`
- [ ] Tạo `api-gateway/package.json`
- [ ] Tạo `api-gateway/tsconfig.json`
- [ ] Tạo `api-gateway/nest-cli.json`
- [ ] Tạo `api-gateway/src/main.ts`
- [ ] Tạo `api-gateway/src/app.module.ts`
- [ ] Tạo folder `src/auth/` và các files bên trong
- [ ] Tạo folder `src/proxy/` và các files bên trong

**Nguồn code**: Artifact "API Gateway - Complete Code"

---

### User Service (Port 3001)

#### Files cần tạo (User Service)

```bash
user-service/
├── Dockerfile
├── package.json
├── tsconfig.json
├── nest-cli.json
└── src/
    ├── main.ts
    ├── app.module.ts
    ├── user/
    │   ├── user.entity.ts
    │   ├── user.service.ts
    │   ├── user.controller.ts
    │   ├── user.module.ts
    │   └── dto/
    │       └── create-user.dto.ts
    └── auth/
        ├── auth.service.ts
        ├── auth.controller.ts
        ├── auth.module.ts
        └── dto/
            └── login.dto.ts
```

#### Checklist (User Service)

- [ ] Tạo `user-service/Dockerfile`
- [ ] Tạo `user-service/package.json`
- [ ] Tạo `user-service/tsconfig.json`
- [ ] Tạo `user-service/nest-cli.json`
- [ ] Tạo `user-service/src/main.ts`
- [ ] Tạo `user-service/src/app.module.ts`
- [ ] Tạo folder `src/user/` và các files
- [ ] Tạo folder `src/user/dto/` và create-user.dto.ts
- [ ] Tạo folder `src/auth/` và các files
- [ ] Tạo folder `src/auth/dto/` và login.dto.ts

**Nguồn code**: Artifact "User Service - Complete Code"

---

### Product Service (Port 3002)

#### Files cần tạo (Product Service)

```bash
product-service/
├── Dockerfile
├── package.json
├── tsconfig.json
├── nest-cli.json
└── src/
    ├── main.ts
    ├── app.module.ts
    └── product/
        ├── product.entity.ts
        ├── product.service.ts
        ├── product.controller.ts
        ├── product.module.ts
        └── dto/
            ├── create-product.dto.ts
            ├── update-product.dto.ts
            └── reduce-stock.dto.ts
```

#### Checklist (Product Service)

- [ ] Tạo `product-service/Dockerfile`
- [ ] Tạo `product-service/package.json`
- [ ] Tạo `product-service/tsconfig.json`
- [ ] Tạo `product-service/nest-cli.json`
- [ ] Tạo `product-service/src/main.ts`
- [ ] Tạo `product-service/src/app.module.ts`
- [ ] Tạo folder `src/product/` và các files
- [ ] Tạo folder `src/product/dto/` và 3 DTO files

**Nguồn code**: Artifact "Product Service - Complete Code"

---

### Order Service (Port 3003)

#### Files cần tạo (Order Service)

```bash
order-service/
├── Dockerfile
├── package.json
├── tsconfig.json
├── nest-cli.json
└── src/
    ├── main.ts
    ├── app.module.ts
    ├── order/
    │   ├── order.entity.ts
    │   ├── order-item.entity.ts
    │   ├── order.service.ts
    │   ├── order.controller.ts
    │   ├── order.module.ts
    │   └── dto/
    │       └── create-order.dto.ts
    └── clients/
        └── product.client.ts
```

#### Checklist (Order Service)

- [ ] Tạo `order-service/Dockerfile`
- [ ] Tạo `order-service/package.json`
- [ ] Tạo `order-service/tsconfig.json`
- [ ] Tạo `order-service/nest-cli.json`
- [ ] Tạo `order-service/src/main.ts`
- [ ] Tạo `order-service/src/app.module.ts`
- [ ] Tạo folder `src/order/` và các files
- [ ] Tạo folder `src/order/dto/` và create-order.dto.ts
- [ ] Tạo folder `src/clients/` và product.client.ts

**Nguồn code**: Artifact "Order Service - Complete Code"

---

## 🚀 Build và Run

### Checklist chạy project

- [ ] Kiểm tra tất cả files đã tạo đúng
- [ ] Verify docker-compose.yml không có lỗi syntax
- [ ] Run: `docker-compose up --build`
- [ ] Đợi tất cả services start (có thể mất 2-3 phút)

### Kiểm tra services đã chạy

- [ ] API Gateway: `curl http://localhost:3000`
- [ ] User Service: `curl http://localhost:3001`
- [ ] Product Service: `curl http://localhost:3002/products`
- [ ] Order Service: `curl http://localhost:3003`
- [ ] PostgreSQL: Port 5432 available
- [ ] Redis: Port 6379 available

---

## 🧪 Testing

### Test Script

- [ ] Tạo file `test-api.sh` từ artifact
- [ ] Chmod: `chmod +x test-api.sh`
- [ ] Run: `./test-api.sh`

### Manual Testing

- [ ] Test đăng ký user
- [ ] Test login và lấy JWT token
- [ ] Test tạo product (với token)
- [ ] Test get products (không cần token)
- [ ] Test tạo order (với token)
- [ ] Test get orders (với token)

---

## 📊 Verify Database

```bash
# Connect to PostgreSQL
docker exec -it ecommerce_postgres psql -U postgres -d ecommerce_db

# Check schemas
\dn

# Check tables in user_schema
SET search_path TO user_schema;
\dt
SELECT * FROM users;

# Check tables in product_schema
SET search_path TO product_schema;
\dt
SELECT * FROM products;

# Check tables in order_schema
SET search_path TO order_schema;
\dt
SELECT * FROM orders;
SELECT * FROM order_items;
```

### Database Checklist

- [ ] Schema `user_schema` tồn tại
- [ ] Schema `product_schema` tồn tại
- [ ] Schema `order_schema` tồn tại
- [ ] Table `users` có data sau test
- [ ] Table `products` có data sau test
- [ ] Table `orders` có data sau test
- [ ] Table `order_items` có data sau test

---

## 🐛 Common Issues & Solutions

### Issue 1: Port already in use

**Error**: `Bind for 0.0.0.0:3000 failed: port is already allocated`

**Solution**:

```bash
# Find process using port
lsof -i :3000
# Kill process
kill -9 <PID>
# Or change port in docker-compose.yml
```

- [ ] Resolved

---

### Issue 2: Database connection failed

**Error**: `Connection error: ECONNREFUSED`

**Solution**:

```bash
# Check PostgreSQL logs
docker-compose logs postgres
# Restart database
docker-compose restart postgres
```

- [ ] Resolved

---

### Issue 3: Services can't connect to each other

**Error**: `ENOTFOUND` hoặc `ECONNREFUSED` giữa các services

**Solution**:

- Check service names trong docker-compose.yml
- Verify environment variables (SERVICE_URL)
- Ensure all services are in same network
- [ ] Resolved

---

### Issue 4: TypeORM synchronize not working

**Error**: Tables not created automatically

**Solution**:

- Check database credentials trong .env
- Verify schema name trong environment
- Check logs: `docker-compose logs user-service`
- [ ] Resolved

---

## ✅ Final Verification

### Project structure correct

- [ ] 4 service folders created
- [ ] docker-compose.yml tại root
- [ ] .env file configured
- [ ] All source files created

### Services running

- [ ] All containers running: `docker-compose ps`
- [ ] No error logs: `docker-compose logs`
- [ ] All ports accessible

### APIs working

- [ ] Can register user
- [ ] Can login and get token
- [ ] Can create products
- [ ] Can get products list
- [ ] Can create orders
- [ ] Can get order history

### Database working

- [ ] All schemas created
- [ ] All tables created
- [ ] Data persists after restart

---

## 🎓 Learning Checklist

Sau khi hoàn thành project, bạn đã học được:

- [ ] Microservices architecture pattern
- [ ] API Gateway pattern
- [ ] Service-to-service communication (HTTP)
- [ ] JWT authentication flow
- [ ] Database per service pattern
- [ ] NestJS framework basics
- [ ] TypeORM for database
- [ ] Docker containerization
- [ ] Docker Compose orchestration
- [ ] RESTful API design

---

## 📚 Next Steps

Sau khi project chạy thành công, có thể mở rộng:

- [ ] Thêm Swagger documentation
- [ ] Implement Redis caching
- [ ] Add rate limiting
- [ ] Write unit tests
- [ ] Add integration tests
- [ ] Implement logging (Winston)
- [ ] Add monitoring (Prometheus/Grafana)
- [ ] Implement circuit breaker pattern
- [ ] Add message queue (RabbitMQ/Kafka)
- [ ] Deploy to cloud (AWS/GCP/Azure)

---

## 🎉 Completion

Khi tất cả checkboxes đã được tick:

- ✅ Project setup hoàn tất
- ✅ Services chạy thành công
- ✅ APIs tested và working
- ✅ Database verified
- ✅ Ready for development!

- **Congratulations! Bạn đã hoàn thành Microservices demo project! 🎊**

---

**Need help?**

- Xem lại documentation artifacts
- Check logs: `docker-compose logs -f`
- Verify environment variables
- Check project structure guide
