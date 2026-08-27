#!/usr/bin/env bash
# ==========================================
# Rise Platform — Automated VPS Deployment Script
# Zero-downtime containerized deployment
# ==========================================

set -e

echo "🚀 [1/5] Checking repository updates..."
git pull origin main || true

echo "📦 [2/5] Building production Docker containers..."
docker compose build

echo "🔄 [3/5] Starting database & cache services..."
docker compose up -d postgres redis

echo "⏳ Waiting for PostgreSQL to become healthy..."
sleep 3
docker compose exec -T postgres pg_isready -U "${POSTGRES_USER:-rise_admin}" -d "${POSTGRES_DB:-rise_production}" || true

echo "🗄️ [4/5] Running Prisma database migrations..."
docker compose run --rm api npx prisma migrate deploy

echo "🚀 [5/5] Launching API Engine, Workers & Admin Studio..."
docker compose up -d

echo "🧹 Pruning old unused Docker images..."
docker image prune -f

echo "✅ =========================================="
echo "✅ Rise Platform successfully deployed!"
echo "✅ API:   http://64.177.41.52:3000/api/v1"
echo "✅ Admin: http://64.177.41.52:4173"
echo "✅ Webhook: https://64-177-41-52.sslip.io/api/v1/billing/webhook"
echo "✅ =========================================="
