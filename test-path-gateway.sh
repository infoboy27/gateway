#!/bin/bash

echo "🧪 Testing Path Gateway Setup"
echo "=============================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to test endpoint
test_endpoint() {
    local url=$1
    local description=$2
    
    echo -n "Testing $description... "
    
    if curl -s -f "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        return 1
    fi
}

# Function to test with timeout
test_with_timeout() {
    local url=$1
    local description=$2
    local timeout=${3:-10}
    
    echo -n "Testing $description (timeout: ${timeout}s)... "
    
    if timeout "$timeout" curl -s -f "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✅ PASS${NC}"
        return 0
    else
        echo -e "${RED}❌ FAIL${NC}"
        return 1
    fi
}

echo ""
echo "1. Checking Docker services..."
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}✅ Docker services are running${NC}"
else
    echo -e "${RED}❌ Docker services are not running${NC}"
    echo "Run: docker-compose up -d"
    exit 1
fi

echo ""
echo "2. Testing Shannon Node endpoints..."

# Test Shannon node RPC
if test_endpoint "http://localhost:26657/status" "Shannon Node RPC"; then
    echo "   RPC endpoint is accessible"
else
    echo "   RPC endpoint is not accessible"
fi

# Test Shannon node gRPC (basic port check)
if netstat -tlnp 2>/dev/null | grep -q ":9090"; then
    echo -e "${GREEN}✅ Shannon Node gRPC port 9090 is listening${NC}"
else
    echo -e "${YELLOW}⚠️  Shannon Node gRPC port 9090 is not listening${NC}"
fi

echo ""
echo "3. Testing Path Gateway endpoints..."

# Test Path gateway health
if test_endpoint "http://localhost:3069/health" "Path Gateway Health"; then
    echo "   Health endpoint is accessible"
else
    echo "   Health endpoint is not accessible"
fi

# Test Path gateway status
if test_endpoint "http://localhost:3069/status" "Path Gateway Status"; then
    echo "   Status endpoint is accessible"
else
    echo "   Status endpoint is not accessible"
fi

echo ""
echo "4. Testing Path Gateway relay functionality..."

# Test basic relay request
echo -n "Testing relay request... "
relay_response=$(curl -s -X POST http://localhost:3069/v1/client/send \
  -H "Content-Type: application/json" \
  -d '{
    "relay_network": "shannon",
    "payload": {
      "data": "test",
      "method": "GET",
      "path": "/",
      "headers": {}
    }
  }' 2>/dev/null)

if [[ $? -eq 0 ]] && [[ -n "$relay_response" ]]; then
    echo -e "${GREEN}✅ PASS${NC}"
    echo "   Response received: $relay_response"
else
    echo -e "${RED}❌ FAIL${NC}"
    echo "   No response or error occurred"
fi

echo ""
echo "5. Checking service logs..."

echo "Shannon Node logs (last 5 lines):"
docker-compose logs --tail=5 shannon-testnet-node

echo ""
echo "Path Gateway logs (last 5 lines):"
docker-compose logs --tail=5 shannon-testnet-gateway

echo ""
echo "🎯 Test Summary:"
echo "=================="

# Count successful tests
passed=0
total=0

# Simple test count (you can enhance this)
if docker-compose ps | grep -q "Up"; then ((passed++)); fi; ((total++))
if curl -s -f "http://localhost:26657/status" > /dev/null 2>&1; then ((passed++)); fi; ((total++))
if curl -s -f "http://localhost:3069/health" > /dev/null 2>&1; then ((passed++)); fi; ((total++))

echo "Tests passed: $passed/$total"

if [[ $passed -eq $total ]]; then
    echo -e "${GREEN}🎉 All tests passed! Your Path Gateway is working correctly.${NC}"
else
    echo -e "${YELLOW}⚠️  Some tests failed. Check the output above for details.${NC}"
fi

echo ""
echo "🔗 Useful endpoints:"
echo "   Shannon Node RPC: http://localhost:26657"
echo "   Shannon Node gRPC: localhost:9090"
echo "   Path Gateway: http://localhost:3069"
echo "   Path Gateway Health: http://localhost:3069/health"
