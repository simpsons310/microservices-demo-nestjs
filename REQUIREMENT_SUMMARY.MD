# 🚀 Microservices E-commerce Demo

## 📋 MÔ TẢ PROJECT

### Tổng quan

Đây là một demo project về **Microservices Architecture** được xây dựng bằng **NestJS** và **TypeScript**. Project mô phỏng một hệ thống e-commerce đơn giản với các chức năng cơ bản: quản lý người dùng, sản phẩm, và đơn hàng.

### Kiến trúc tổng quan

```text
Client/Browser
       ↓
API Gateway (Port 3000)
  [Authentication & Routing]
       ↓
   ┌───┴────┬──────────┬──────────┐
   ↓        ↓          ↓          ↓
User     Product    Order     [HTTP REST]
Service  Service   Service
(3001)   (3002)    (3003)
   ↓        ↓          ↓
   └────────┴──────────┘
         PostgreSQL
    (Multiple Schemas)
```

---

## 🛠️ TECH STACK

```text
| Component | Technology |
|-----------|-----------|
| Framework | NestJS (TypeScript) |
| Database | PostgreSQL |
| Cache | Redis |
| ORM | TypeORM |
| Authentication | JWT |
| Containerization | Docker & Docker Compose |
| API Communication | HTTP/REST |
```

---

## 🏗️ SERVICES

### 1. API Gateway (Port 3000)

**Chức năng:**

- Entry point duy nhất cho tất cả requests từ client
- JWT authentication và authorization
- Routing requests đến các microservices
- Global error handling
- Request logging

**Endpoints:**

- `/api/auth/*` → User Service
- `/api/users/*` → User Service
- `/api/products/*` → Product Service
- `/api/orders/*` → Order Service

### 2. User Service (Port 3001)

**Chức năng:**

- Quản lý người dùng
- Authentication (Login/Register)
- JWT token generation
- User profile management

**Database:** PostgreSQL schema `user_schema`

**API Endpoints:**

- `POST /auth/register` - Đăng ký tài khoản mới
- `POST /auth/login` - Đăng nhập
- `GET /users/me` - Lấy thông tin profile (cần JWT)

### 3. Product Service (Port 3002)

**Chức năng:**

- CRUD sản phẩm
- Quản lý inventory/stock
- Cung cấp API cho Order Service check stock

**Database:** PostgreSQL schema `product_schema`

**API Endpoints:**

- `GET /products` - Lấy danh sách sản phẩm (có pagination)
- `GET /products/:id` - Lấy chi tiết sản phẩm
- `POST /products` - Tạo sản phẩm mới (admin)
- `PUT /products/:id` - Cập nhật sản phẩm (admin)
- `DELETE /products/:id` - Xóa sản phẩm (admin)
- `POST /products/:id/reduce-stock` - Giảm stock (internal API)

### 4. Order Service (Port 3003)

**Chức năng:**

- Tạo đơn hàng
- Quản lý đơn hàng
- Gọi Product Service để check và giảm stock

**Database:** PostgreSQL schema `order_schema`

**API Endpoints:**

- `POST /orders` - Tạo đơn hàng mới (cần JWT)
- `GET /orders` - Lấy danh sách đơn hàng của user (cần JWT)
- `GET /orders/:id` - Lấy chi tiết đơn hàng (cần JWT)

---

## 💾 DATABASE DESIGN

### PostgreSQL Database: `ecommerce_db`

#### Schema: `user_schema`

```sql
Table: users
- id: UUID (Primary Key)
- email: VARCHAR (Unique)
- password: VARCHAR (Hashed)
- name: VARCHAR
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

#### Schema: `product_schema`

```sql
Table: products
- id: UUID (Primary Key)
- name: VARCHAR
- description: TEXT
- price: DECIMAL
- stock: INTEGER
- image_url: VARCHAR
- created_at: TIMESTAMP
- updated_at: TIMESTAMP
```

#### Schema: `order_schema`

```sql
Table: orders
- id: UUID (Primary Key)
- user_id: UUID
- total_amount: DECIMAL
- status: ENUM (pending, confirmed, cancelled)
- created_at: TIMESTAMP
- updated_at: TIMESTAMP

Table: order_items
- id: UUID (Primary Key)
- order_id: UUID (Foreign Key)
- product_id: UUID
- product_name: VARCHAR
- quantity: INTEGER
- price: DECIMAL
```

---

## 🔐 AUTHENTICATION FLOW

```text
1. User đăng ký/đăng nhập
   ↓
2. User Service verify credentials
   ↓
3. Generate JWT token
   ↓
4. Client lưu token
   ↓
5. Mọi request sau đều gửi kèm token trong header:
   Authorization: Bearer <token>
   ↓
6. API Gateway verify token
   ↓
7. Forward request đến service tương ứng
```

---

## 📊 DATA FLOW: TẠO ĐƠN HÀNG

```text
1. Client → API Gateway: POST /api/orders
   Headers: { Authorization: Bearer <JWT> }
   Body: {
     items: [
       { productId: "...", quantity: 2 }
     ]
   }

2. API Gateway:
   - Verify JWT token
   - Extract user info
   - Forward to Order Service

3. Order Service:
   - Nhận request với user info
   - Loop qua từng product:
     → Gọi Product Service: GET /products/:id
     → Check stock availability
   
4. Product Service:
   - Return product info và stock

5. Order Service:
   - Nếu stock đủ:
     → Calculate total amount
     → Create order trong database
     → Gọi Product Service để reduce stock
     → Return success
   - Nếu stock không đủ:
     → Return error

6. API Gateway → Client: Return response
```

---

## 🚀 HƯỚNG DẪN CHẠY PROJECT

### Yêu cầu hệ thống

- Node.js >= 18.x
- Docker & Docker Compose
- Git

### Bước 1: Clone project

```bash
# Clone repository (giả sử bạn đã có code)
git clone <repository-url>
cd microservices-ecommerce
```

### Bước 2: Cấu trúc thư mục

```text
microservices-ecommerce/
├── docker-compose.yml
├── .env.example
├── api-gateway/
├── user-service/
├── product-service/
└── order-service/
```

### Bước 3: Setup environment variables

```bash
# Copy file .env.example thành .env
cp .env.example .env

# Nội dung file .env
DATABASE_HOST=postgres
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres123
DATABASE_NAME=ecommerce_db

REDIS_HOST=redis
REDIS_PORT=6379

JWT_SECRET=your-super-secret-jwt-key-change-this
JWT_EXPIRES_IN=1d

USER_SERVICE_URL=http://user-service:3001
PRODUCT_SERVICE_URL=http://product-service:3002
ORDER_SERVICE_URL=http://order-service:3003
```

### Bước 4: Chạy với Docker Compose

```bash
# Build và start tất cả services
docker-compose up --build

# Hoặc chạy ở background
docker-compose up -d --build

# Xem logs
docker-compose logs -f

# Stop services
docker-compose down

# Stop và xóa volumes (database data)
docker-compose down -v
```

### Bước 5: Kiểm tra services

Sau khi chạy thành công, các services sẽ available tại:

- **API Gateway**: http://localhost:3000
- **User Service**: http://localhost:3001
- **Product Service**: http://localhost:3002
- **Order Service**: http://localhost:3003
- **PostgreSQL**: localhost:5432
- **Redis**: localhost:6379

### Bước 6: Test API

#### 1. Đăng ký user mới

```bash
curl -X POST http://localhost:3000/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "name": "Test User"
  }'
```

#### 2. Login

```bash
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'

# Response sẽ trả về:
# {
#   "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
# }
```

#### 3. Tạo sản phẩm (cần token)

```bash
curl -X POST http://localhost:3000/api/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "name": "MacBook Pro",
    "description": "Apple MacBook Pro 16 inch",
    "price": 2499.99,
    "stock": 10,
    "imageUrl": "https://example.com/macbook.jpg"
  }'
```

#### 4. Lấy danh sách sản phẩm

```bash
curl http://localhost:3000/api/products
```

#### 5. Tạo đơn hàng (cần token)

```bash
curl -X POST http://localhost:3000/api/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -d '{
    "items": [
      {
        "productId": "product-uuid-here",
        "quantity": 2
      }
    ]
  }'
```

#### 6. Xem đơn hàng của mình (cần token)

```bash
curl http://localhost:3000/api/orders \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

---

## 🔧 DEVELOPMENT MODE

Nếu muốn chạy từng service riêng lẻ để development:

### 1. Start PostgreSQL và Redis

```bash
docker-compose up postgres redis -d
```

### 2. Install dependencies cho từng service

```bash
cd user-service && npm install
cd ../product-service && npm install
cd ../order-service && npm install
cd ../api-gateway && npm install
```

### 3. Chạy từng service

```bash
# Terminal 1: User Service
cd user-service
npm run start:dev

# Terminal 2: Product Service
cd product-service
npm run start:dev

# Terminal 3: Order Service
cd order-service
npm run start:dev

# Terminal 4: API Gateway
cd api-gateway
npm run start:dev
```

---

## 📝 API DOCUMENTATION

### Authentication

- **Register**

```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}

Response: 201 Created
{
  "id": "uuid",
  "email": "user@example.com",
  "name": "John Doe"
}
```

- **Login**

```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response: 200 OK
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Products

- **Get All Products**

```http
GET /api/products?page=1&limit=10

Response: 200 OK
{
  "data": [
    {
      "id": "uuid",
      "name": "Product Name",
      "description": "Description",
      "price": 99.99,
      "stock": 50
    }
  ],
  "total": 100,
  "page": 1,
  "limit": 10
}
```

- **Create Product** (Requires Auth)

```http
POST /api/products
Authorization: Bearer <token>
Content-Type: application/json

{
  "name": "MacBook Pro",
  "description": "Apple MacBook Pro 16 inch",
  "price": 2499.99,
  "stock": 10,
  "imageUrl": "https://example.com/image.jpg"
}

Response: 201 Created
```

### Orders

**Create Order** (Requires Auth)

```http
POST /api/orders
Authorization: Bearer <token>
Content-Type: application/json

{
  "items": [
    {
      "productId": "uuid",
      "quantity": 2
    }
  ]
}

Response: 201 Created
{
  "id": "uuid",
  "userId": "uuid",
  "totalAmount": 199.98,
  "status": "pending",
  "items": [...]
}
```

**Get My Orders** (Requires Auth)

```http
GET /api/orders
Authorization: Bearer <token>

Response: 200 OK
[
  {
    "id": "uuid",
    "totalAmount": 199.98,
    "status": "pending",
    "createdAt": "2024-01-01T00:00:00Z"
  }
]
```

---

## 🐛 TROUBLESHOOTING

### Port đã được sử dụng

```bash
# Check port đang được sử dụng
lsof -i :3000  # hoặc port khác

# Kill process
kill -9 <PID>
```

### Database connection error

```bash
# Restart PostgreSQL container
docker-compose restart postgres

# Check logs
docker-compose logs postgres
```

### Service không start

```bash
# Rebuild containers
docker-compose down
docker-compose up --build

# Check logs của service cụ thể
docker-compose logs user-service
```

---

## 📚 HỌC THÊM

### Design Patterns trong project

1. **API Gateway Pattern** - Single entry point
2. **Database per Schema** - Data isolation
3. **Service-to-Service Communication** - HTTP REST
4. **JWT Authentication** - Stateless auth

### Microservices Best Practices

- ✅ Loose coupling giữa các services
- ✅ Single responsibility per service
- ✅ Independent deployment
- ✅ Decentralized data management
- ✅ Failure isolation

### Next Steps để mở rộng

- [ ] Thêm Swagger/OpenAPI documentation
- [ ] Implement logging với Winston
- [ ] Thêm monitoring (Prometheus + Grafana)
- [ ] Circuit breaker pattern
- [ ] API rate limiting
- [ ] Unit tests & E2E tests
- [ ] Message queue (RabbitMQ/Kafka) cho async tasks

---

## 📞 SUPPORT

Nếu có vấn đề gì, bạn có thể:

1. Check logs: `docker-compose logs -f`
2. Verify environment variables trong `.env`
3. Ensure Docker và Docker Compose đang chạy
4. Check port conflicts

---

## 📄 LICENSE

MIT License - Free to use for learning purposes

---

- **Happy Learning Microservices! 🎉**
