//
//  admin.test.ts
//  RiseServer
//
//  Integration tests for Admin API endpoints and RBAC security guards
//

import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { FastifyInstance } from 'fastify';
import { buildApp } from '@/app.js';

describe('Admin API & RBAC Integration Tests', () => {
  let app: FastifyInstance;
  let adminToken: string;
  let regularUserToken: string;

  beforeAll(async () => {
    app = await buildApp();
    await app.ready();

    adminToken = await app.jwt.sign({
      userId: '00000000-0000-0000-0000-000000000001',
      role: 'ADMIN',
      subscriptionTier: 'LIFETIME',
    });

    regularUserToken = await app.jwt.sign({
      userId: '00000000-0000-0000-0000-000000000002',
      role: 'USER',
      subscriptionTier: 'FREE',
    });
  });

  afterAll(async () => {
    await app.close();
  });

  it('GET /api/v1/admin/analytics/summary should reject unauthenticated requests with 401', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/analytics/summary',
    });

    expect(response.statusCode).toBe(401);
  });

  it('GET /api/v1/admin/analytics/summary should reject non-admin users with 403', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/analytics/summary',
      headers: {
        authorization: `Bearer ${regularUserToken}`,
      },
    });

    expect(response.statusCode).toBe(403);
  });

  it('GET /api/v1/admin/analytics/summary should return platform metrics for admin', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/analytics/summary',
      headers: {
        authorization: `Bearer ${adminToken}`,
      },
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(body.data).toHaveProperty('totalUsers');
    expect(body.data).toHaveProperty('conversionRate');
  });

  it('GET /api/v1/admin/packs should return all packs for admin', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/packs',
      headers: {
        authorization: `Bearer ${adminToken}`,
      },
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(Array.isArray(body.data)).toBe(true);
  });

  it('GET /api/v1/admin/affirmations should return affirmations list for admin', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/affirmations',
      headers: {
        authorization: `Bearer ${adminToken}`,
      },
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(Array.isArray(body.data)).toBe(true);
    expect(body.meta).toHaveProperty('total');
  });

  it('GET /api/v1/admin/users should return user directory for admin', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/admin/users',
      headers: {
        authorization: `Bearer ${adminToken}`,
      },
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(Array.isArray(body.data)).toBe(true);
    expect(body.meta).toHaveProperty('total');
  });
});
