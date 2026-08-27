//
//  app.test.ts
//  RiseServer
//
//  Integration tests for server routes, legal endpoints, OpenAPI, RBAC guards, and new modules
//

import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { FastifyInstance } from 'fastify';
import { buildApp } from '@/app.js';

describe('API Server Integration Tests', () => {
  let app: FastifyInstance;

  beforeAll(async () => {
    app = await buildApp();
    await app.ready();
  });

  afterAll(async () => {
    await app.close();
  });

  it('GET /privacy should return App Store compliant privacy document', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/privacy',
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(body.data.title).toContain('Privacy Policy');
  });

  it('GET /terms should return Terms of Service document', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/terms',
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(body.data.title).toContain('Terms of Service');
  });

  it('GET /docs/ should serve interactive OpenAPI / Swagger UI', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/docs/',
    });

    expect(response.statusCode).toBe(200);
  });

  it('GET /api/v1/user/me should reject unauthenticated requests with 401', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/user/me',
    });

    expect(response.statusCode).toBe(401);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe('UNAUTHORIZED');
  });

  it('POST /api/v1/sync should reject unauthenticated sync attempts with 401', async () => {
    const response = await app.inject({
      method: 'POST',
      url: '/api/v1/sync',
      payload: {
        journals: [],
        savedItems: [],
        intentions: [],
      },
    });

    expect(response.statusCode).toBe(401);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe('UNAUTHORIZED');
  });

  it('POST /api/v1/auth/register with invalid email should return 400 validation error', async () => {
    const response = await app.inject({
      method: 'POST',
      url: '/api/v1/auth/register',
      payload: {
        email: 'invalid-email-string',
        password: 'short',
      },
    });

    expect(response.statusCode).toBe(400);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe('VALIDATION_ERROR');
  });

  it('GET /api/v1/progress/milestones should reject unauthenticated requests with 401', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/progress/milestones',
    });

    expect(response.statusCode).toBe(401);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe('UNAUTHORIZED');
  });

  it('POST /api/v1/admin/quotes should reject non-admin regular users with 403 Forbidden', async () => {
    const regularUserToken = await app.jwt.sign({
      userId: '11111111-1111-1111-1111-111111111111',
      role: 'USER',
      subscriptionTier: 'FREE',
    });

    const response = await app.inject({
      method: 'POST',
      url: '/api/v1/admin/quotes',
      headers: {
        authorization: `Bearer ${regularUserToken}`,
      },
      payload: {
        quote: 'A test quote that should be rejected due to lack of admin permissions.',
        author: 'Marcus Aurelius',
        category: 'Stoicism',
      },
    });

    expect(response.statusCode).toBe(403);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe('FORBIDDEN');
  });

  it('POST /api/v1/media/upload-signature should reject unauthenticated requests with 401', async () => {
    const response = await app.inject({
      method: 'POST',
      url: '/api/v1/media/upload-signature',
      payload: {
        folder: 'avatars',
      },
    });

    expect(response.statusCode).toBe(401);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe('UNAUTHORIZED');
  });

  it('GET /api/v1/analytics/metrics should reject non-admin users with 401/403', async () => {
    // 1. Unauthenticated request -> 401
    const unauthResponse = await app.inject({
      method: 'GET',
      url: '/api/v1/analytics/metrics',
    });
    expect(unauthResponse.statusCode).toBe(401);

    // 2. Regular user request -> 403
    const regularToken = await app.jwt.sign({
      userId: '22222222-2222-2222-2222-222222222222',
      role: 'USER',
      subscriptionTier: 'PRO_ANNUAL',
    });
    const regularResponse = await app.inject({
      method: 'GET',
      url: '/api/v1/analytics/metrics',
      headers: {
        authorization: `Bearer ${regularToken}`,
      },
    });
    expect(regularResponse.statusCode).toBe(403);
  });

  it('GET /api/v1/packs should return packs list', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/packs',
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(Array.isArray(body.data)).toBe(true);
  });

  it('GET /api/v1/intentions/suggestions should return curated focus suggestions', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/intentions/suggestions',
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(Array.isArray(body.data)).toBe(true);
    expect(body.data.length).toBeGreaterThan(0);
  });

  it('GET /api/v1/discover should return consolidated discovery hub', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/discover',
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(body.data).toHaveProperty('breathingResets');
    expect(body.data).toHaveProperty('categories');
  });

  it('GET /api/v1/discover/search with query should return search results envelope', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/discover/search?q=focus',
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(body.data).toHaveProperty('totalMatches');
  });

  it('GET /api/v1/motivation/affirmations/daily should return a daily affirmation', async () => {
    const response = await app.inject({
      method: 'GET',
      url: '/api/v1/motivation/affirmations/daily',
    });

    expect(response.statusCode).toBe(200);
    const body = JSON.parse(response.body);
    expect(body.success).toBe(true);
    expect(body.data).toHaveProperty('text');
  });
});
