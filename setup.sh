#!/bin/bash

# MORA4ME Shopware Development Environment Setup Script
# This script automates the complete setup process

set -e

echo "🚀 MORA4ME Shopware Development Environment Setup"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is running
check_docker() {
    print_status "Checking Docker..."
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker Desktop and try again."
        exit 1
    fi
    print_success "Docker is running"
}

# Check if docker-compose is available
check_docker_compose() {
    print_status "Checking Docker Compose..."
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose is not installed. Please install Docker Desktop."
        exit 1
    fi
    print_success "Docker Compose is available"
}

# Start Docker containers
start_containers() {
    print_status "Starting Docker containers..."
    docker-compose up -d
    print_success "Docker containers started"
}

# Wait for services to be ready
wait_for_services() {
    print_status "Waiting for services to be ready..."
    
    # Wait for MySQL
    print_status "Waiting for MySQL..."
    until docker-compose exec -T mysql mysqladmin ping -h"localhost" --silent; do
        sleep 1
    done
    print_success "MySQL is ready"
    
    # Wait for Redis
    print_status "Waiting for Redis..."
    until docker-compose exec -T redis redis-cli ping | grep -q PONG; do
        sleep 1
    done
    print_success "Redis is ready"
    
    # Wait for OpenSearch
    print_status "Waiting for OpenSearch..."
    until curl -s http://localhost:9200/_cluster/health | grep -q '"status":"green\|yellow"'; do
        sleep 5
    done
    print_success "OpenSearch is ready"
}

# Install PHP dependencies
install_php_deps() {
    print_status "Installing PHP dependencies..."
    docker-compose exec -T php composer install --no-interaction --prefer-dist
    print_success "PHP dependencies installed"
}

# Install Node.js dependencies
install_node_deps() {
    print_status "Installing Node.js dependencies for Administration..."
    docker-compose exec -T -w /var/www/html/src/Administration/Resources/app/administration node npm install
    
    print_status "Installing Node.js dependencies for Storefront..."
    docker-compose exec -T -w /var/www/html/src/Storefront/Resources/app/storefront node npm install
    
    print_success "Node.js dependencies installed"
}

# Setup Shopware
setup_shopware() {
    print_status "Setting up Shopware database..."
    docker-compose exec -T php bin/console system:install --create-database --basic-setup --no-interaction
    print_success "Shopware database setup completed"
}

# Clear cache
clear_cache() {
    print_status "Clearing cache..."
    docker-compose exec -T php bin/console cache:clear
    print_success "Cache cleared"
}

# Display final information
show_info() {
    echo ""
    echo "🎉 Setup completed successfully!"
    echo "================================"
    echo ""
    echo "📍 Access Points:"
    echo "   • Storefront:     http://localhost"
    echo "   • Admin Panel:    http://localhost/admin"
    echo "   • PhpMyAdmin:     http://localhost:8080"
    echo "   • MailHog:        http://localhost:8025"
    echo "   • OpenSearch:     http://localhost:5601"
    echo ""
    echo "🔐 Default Admin Credentials:"
    echo "   • Username: admin"
    echo "   • Password: shopware"
    echo ""
    echo "🛠️  Development Commands:"
    echo "   • Start Admin Dev:    cd src/Administration/Resources/app/administration && npm run dev"
    echo "   • Start Storefront:   cd src/Storefront/Resources/app/storefront && npm run watch"
    echo "   • Clear Cache:        docker-compose exec php bin/console cache:clear"
    echo "   • Run Tests:          docker-compose exec php vendor/bin/phpunit"
    echo ""
    echo "📚 Next Steps:"
    echo "   1. Open VSCode: code ."
    echo "   2. Install recommended extensions"
    echo "   3. Start development servers"
    echo "   4. Happy coding! 🚀"
    echo ""
}

# Main execution
main() {
    check_docker
    check_docker_compose
    start_containers
    wait_for_services
    install_php_deps
    install_node_deps
    setup_shopware
    clear_cache
    show_info
}

# Trap to cleanup on script exit
cleanup() {
    if [ $? -ne 0 ]; then
        print_error "Setup failed. Check the logs above for details."
        print_warning "You can try running individual commands manually."
    fi
}

trap cleanup EXIT

# Run main function
main "$@"