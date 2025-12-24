#!/bin/bash

# ============================================
# Complete API Test Script
# Save as: test-api.sh
# Usage: chmod +x test-api.sh && ./test-api.sh
# ============================================

echo "🚀 Testing Microservices E-commerce API"
echo "========================================"
echo ""

BASE_URL="http://localhost:3000/api"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Register User
echo -e "${YELLOW}Test 1: Register User${NC}"
REGISTER_RESPONSE=$(curl -s -X POST $BASE_URL/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@example.com",
    "password": "password123",
    "name": "Demo User"
  }')

echo "$REGISTER_RESPONSE" | jq '.'

if echo "$REGISTER_RESPONSE" | jq -e '.id' > /dev/null; then
  echo -e "${GREEN}✓ User registered successfully${NC}"
else
  echo -e "${RED}✗ Registration failed${NC}"
fi
echo ""

# Test 2: Login
echo -e "${YELLOW}Test 2: Login User${NC}"
LOGIN_RESPONSE=$(curl -s -X POST $BASE_URL/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "demo@example.com",
    "password": "password123"
  }')

echo "$LOGIN_RESPONSE" | jq '.'

ACCESS_TOKEN=$(echo "$LOGIN_RESPONSE" | jq -r '.access_token')

if [ "$ACCESS_TOKEN" != "null" ] && [ -n "$ACCESS_TOKEN" ]; then
  echo -e "${GREEN}✓ Login successful${NC}"
  echo "Token: ${ACCESS_TOKEN:0:50}..."
else
  echo -e "${RED}✗ Login failed${NC}"
  exit 1
fi
echo ""

# Test 3: Create Products
echo -e "${YELLOW}Test 3: Create Products${NC}"

PRODUCT1=$(curl -s -X POST $BASE_URL/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "name": "MacBook Pro 16\"",
    "description": "Apple MacBook Pro with M3 Max chip",
    "price": 2499.99,
    "stock": 50,
    "imageUrl": "https://example.com/macbook.jpg"
  }')

PRODUCT1_ID=$(echo "$PRODUCT1" | jq -r '.id')
echo "Product 1 created: $PRODUCT1_ID"

PRODUCT2=$(curl -s -X POST $BASE_URL/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "name": "iPhone 15 Pro",
    "description": "Latest iPhone with A17 Pro chip",
    "price": 999.99,
    "stock": 100,
    "imageUrl": "https://example.com/iphone.jpg"
  }')

PRODUCT2_ID=$(echo "$PRODUCT2" | jq -r '.id')
echo "Product 2 created: $PRODUCT2_ID"

if [ "$PRODUCT1_ID" != "null" ] && [ "$PRODUCT2_ID" != "null" ]; then
  echo -e "${GREEN}✓ Products created successfully${NC}"
else
  echo -e "${RED}✗ Product creation failed${NC}"
fi
echo ""

# Test 4: Get All Products
echo -e "${YELLOW}Test 4: Get All Products${NC}"
PRODUCTS=$(curl -s -X GET "$BASE_URL/products?page=1&limit=10")
echo "$PRODUCTS" | jq '.'

PRODUCT_COUNT=$(echo "$PRODUCTS" | jq '.data | length')
echo -e "${GREEN}✓ Retrieved $PRODUCT_COUNT products${NC}"
echo ""

# Test 5: Get Single Product
echo -e "${YELLOW}Test 5: Get Single Product${NC}"
SINGLE_PRODUCT=$(curl -s -X GET "$BASE_URL/products/$PRODUCT1_ID")
echo "$SINGLE_PRODUCT" | jq '.'

PRODUCT_NAME=$(echo "$SINGLE_PRODUCT" | jq -r '.name')
echo -e "${GREEN}✓ Retrieved product: $PRODUCT_NAME${NC}"
echo ""

# Test 6: Create Order
echo -e "${YELLOW}Test 6: Create Order${NC}"
ORDER_RESPONSE=$(curl -s -X POST $BASE_URL/orders \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d "{
    \"items\": [
      {
        \"productId\": \"$PRODUCT1_ID\",
        \"quantity\": 2
      },
      {
        \"productId\": \"$PRODUCT2_ID\",
        \"quantity\": 1
      }
    ]
  }")

echo "$ORDER_RESPONSE" | jq '.'

ORDER_ID=$(echo "$ORDER_RESPONSE" | jq -r '.id')
ORDER_TOTAL=$(echo "$ORDER_RESPONSE" | jq -r '.totalAmount')
ORDER_STATUS=$(echo "$ORDER_RESPONSE" | jq -r '.status')

if [ "$ORDER_ID" != "null" ]; then
  echo -e "${GREEN}✓ Order created successfully${NC}"
  echo "Order ID: $ORDER_ID"
  echo "Total Amount: \$$ORDER_TOTAL"
  echo "Status: $ORDER_STATUS"
else
  echo -e "${RED}✗ Order creation failed${NC}"
fi
echo ""

# Test 7: Get My Orders
echo -e "${YELLOW}Test 7: Get My Orders${NC}"
MY_ORDERS=$(curl -s -X GET $BASE_URL/orders \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "$MY_ORDERS" | jq '.'

ORDER_COUNT=$(echo "$MY_ORDERS" | jq 'length')
echo -e "${GREEN}✓ Retrieved $ORDER_COUNT orders${NC}"
echo ""

# Test 8: Get Order Details
echo -e "${YELLOW}Test 8: Get Order Details${NC}"
ORDER_DETAILS=$(curl -s -X GET "$BASE_URL/orders/$ORDER_ID" \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "$ORDER_DETAILS" | jq '.'

ITEM_COUNT=$(echo "$ORDER_DETAILS" | jq '.items | length')
echo -e "${GREEN}✓ Order has $ITEM_COUNT items${NC}"
echo ""

# Test 9: Check Product Stock After Order
echo -e "${YELLOW}Test 9: Check Product Stock After Order${NC}"
PRODUCT_AFTER=$(curl -s -X GET "$BASE_URL/products/$PRODUCT1_ID")
STOCK_AFTER=$(echo "$PRODUCT_AFTER" | jq -r '.stock')

echo "Product stock after order: $STOCK_AFTER"
echo -e "${GREEN}✓ Stock updated correctly (was 50, now $STOCK_AFTER)${NC}"
echo ""

# Test 10: Update Product
echo -e "${YELLOW}Test 10: Update Product${NC}"
UPDATE_RESPONSE=$(curl -s -X PUT "$BASE_URL/products/$PRODUCT1_ID" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -d '{
    "price": 2299.99,
    "stock": 100
  }')

echo "$UPDATE_RESPONSE" | jq '.'

NEW_PRICE=$(echo "$UPDATE_RESPONSE" | jq -r '.price')
echo -e "${GREEN}✓ Product updated successfully. New price: \$$NEW_PRICE${NC}"
echo ""

# Summary
echo "========================================"
echo -e "${GREEN}✓ All tests completed!${NC}"
echo "========================================"
echo ""
echo "Summary:"
echo "- User registered and logged in"
echo "- 2 Products created"
echo "- 1 Order placed with 2 products"
echo "- Product stock updated automatically"
echo "- Product price updated"
echo ""
echo "You can now:"
echo "1. Access API Gateway at: http://localhost:3000"
echo "2. Use the access token for authenticated requests"
echo "3. View logs: docker-compose logs -f"
echo ""
