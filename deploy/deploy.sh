#!/usr/bin/env bash
# ==========================================
# Rise Platform — Automated VPS Deployment Script
# Zero-downtime containerized deployment
# ==========================================

set -e

echo "🚀 [1/5] Pulling latest repository updates..."
git pull origin main

echo "📦 [2/5] Building production Docker containers..."
docker compose build --pull

echo "🔄 [3/5] Starting database & cache services..."
docker compose up -d postgres redis

echo "⏳ Waiting for PostgreSQL to become healthy..."
docker compose exec -T postgres pg_isready -U "${POSTGRES_USER:-rise_admin}" -d "${POSTGRES_DB:-rise_production}"

echo "🗄️ [4/5] Running Prisma database migrations..."
docker compose run --rm api npx prisma migrate deploy

echo "🚀 [5/5] Launching API Engine, Workers & Admin Studio..."
docker compose up -d

echo "🧹 Pruning old unused Docker images..."
docker image prune -f

echo "✅ =========================================="
echo "✅ Rise Platform successfully deployed!"
echo "✅ API:   http://localhost:3000 (or https://api.riseapp.com)"
echo "✅ Admin: http://localhost:4173 (or https://admin.riseapp.com)"
echo "✅ =========================================="
