#!/bin/bash

# Colors
GREEN='\033[0;32m'
NC='\033[0m' # No Color

clear

# ASCII Art
echo -e "${GREEN}"
echo "██╗  ██╗██╗███╗   ███╗ █████╗ ███╗   ██╗███████╗██╗   ██╗██████╗ ██╗      █████╗ ██╗   ██╗███████╗"
echo "██║  ██║██║████╗ ████║██╔══██╗████╗  ██║██╔════╝██║   ██║██╔══██╗██║     ██╔══██╗██║   ██║██╔════╝"
echo "███████║██║██╔████╔██║███████║██╔██╗ ██║█████╗  ██║   ██║██████╔╝██║     ███████║██║   ██║███████╗"
echo "██╔══██║██║██║╚██╔╝██║██╔══██║██║╚██╗██║██╔══╝  ██║   ██║██╔═══╝ ██║     ██╔══██║██║   ██║╚════██║"
echo "██║  ██║██║██║ ╚═╝ ██║██║  ██║██║ ╚████║███████╗╚██████╔╝██║     ███████╗██║  ██║╚██████╔╝███████║"
echo "╚═╝  ╚═╝╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝"
echo -e "${NC}"

echo "🔄 Updating system packages..."
apt update -y

echo "🐳 Installing Docker Compose..."
apt install docker-compose -y

echo "📥 Cloning Pterodactyl Docker repository..."
git clone https://github.com/YoshiWalsh/docker-pterodactyl-panel

cd docker-pterodactyl-panel || exit

echo "🚀 Launching Docker containers..."
docker-compose up -d

echo "⏱ Waiting for containers to boot (5s)..."
sleep 5

echo "🔍 Listing Docker containers..."
docker ps

CONTAINER_NAME=$(docker ps --format '{{.Names}}' | grep php-fpm)

if [ -z "$CONTAINER_NAME" ]; then
  echo -e "${RED}❌ php-fpm container not found. Something may have gone wrong.${NC}"
  exit 1
fi

echo "👤 Creating admin user inside container: $CONTAINER_NAME"
docker exec -it "$CONTAINER_NAME" php artisan p:user:make

echo -e "${GREEN}✅ Pterodactyl Panel setup complete!"
echo -e "Made by HimanshuPlayz${NC}"
