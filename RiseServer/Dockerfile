# ==========================================
# Rise Server — Production Multi-Stage Dockerfile
# Optimized for Node.js 20 Alpine & Fastify
# ==========================================

# ------------------------------------------
# Stage 1: Build & TypeScript Compilation
# ------------------------------------------
FROM node:20-alpine AS builder

WORKDIR /app

# Install build dependencies for native modules (e.g. argon2, openssl)
RUN apk add --no-cache python3 make g++ libc6-compat openssl

COPY package*.json ./
COPY tsconfig*.json ./
COPY prisma ./prisma/

# Install all dependencies (including devDependencies for build)
RUN npm ci

# Generate Prisma Client
RUN npx prisma generate

# Copy source code and build production bundle
COPY src ./src/
RUN npm run build

# ------------------------------------------
# Stage 2: Production Runtime
# ------------------------------------------
FROM node:20-alpine AS runner

WORKDIR /app

# Install runtime dependencies (OpenSSL for Prisma engine)
RUN apk add --no-cache openssl curl dumb-init

ENV NODE_ENV=production
ENV PORT=3000
ENV HOST=0.0.0.0

# Create non-root user for security
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 riseuser

COPY package*.json ./
COPY prisma ./prisma/

# Install only production dependencies
RUN npm ci --only=production && \
    npx prisma generate && \
    npm cache clean --force

# Copy compiled code from builder
COPY --from=builder /app/dist ./dist

# Set file permissions for non-root execution
RUN chown -R riseuser:nodejs /app

USER riseuser

EXPOSE 3000

# Healthcheck pinging Fastify /health endpoint
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["node", "dist/server.js"]
