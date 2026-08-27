//
//  auth.middleware.ts
//  RiseServer
//
//  JWT authentication and Role-Based Access Control (RBAC) guard middlewares
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { errorResponse } from '@/utils/response.js';
import '@fastify/jwt';

export interface AuthUserPayload {
  userId: string;
  email?: string;
  role: 'USER' | 'CURATOR' | 'ADMIN';
  subscriptionTier: string;
}

declare module '@fastify/jwt' {
  interface FastifyJWT {
    payload: AuthUserPayload;
    user: AuthUserPayload;
  }
}

/**
 * Middleware enforcing valid JWT bearer authentication.
 */
export async function authenticate(request: FastifyRequest, reply: FastifyReply) {
  try {
    const decoded = await request.jwtVerify<AuthUserPayload>();
    request.user = decoded;
  } catch {
    return reply.status(401).send(errorResponse('UNAUTHORIZED', 'Invalid or expired authentication token'));
  }
}

/**
 * Middleware enforcing Role-Based Access Control (RBAC).
 */
export function requireRole(...allowedRoles: Array<'USER' | 'CURATOR' | 'ADMIN'>) {
  return async (request: FastifyRequest, reply: FastifyReply) => {
    if (!request.user || !allowedRoles.includes(request.user.role)) {
      return reply.status(403).send(errorResponse('FORBIDDEN', 'You do not have permission to access this administrative resource'));
    }
  };
}

/**
 * Middleware that populates request.user if a valid token is supplied, without blocking unauthenticated guests.
 */
export async function optionalAuthenticate(request: FastifyRequest) {
  try {
    const decoded = await request.jwtVerify<AuthUserPayload>();
    request.user = decoded;
  } catch {
    // Proceed as unauthenticated guest
  }
}
