//
//  errorHandler.ts
//  RiseServer
//
//  Centralized error handling middleware conforming to RFC 7807 Problem Details
//

import { FastifyError, FastifyReply, FastifyRequest } from 'fastify';
import { ZodError } from 'zod';
import { Prisma } from '@prisma/client';
import { errorResponse } from '@/utils/response.js';
import { logger } from '@/utils/logger.js';

export function errorHandler(error: FastifyError, request: FastifyRequest, reply: FastifyReply) {
  const requestId = request.id;

  // 1. Zod / Fastify Validation Errors
  if (error instanceof ZodError || error.code === 'FST_ERR_VALIDATION') {
    let formattedErrors: unknown = error.message;

    if (error instanceof ZodError) {
      formattedErrors = error.errors.map((err) => ({
        field: err.path.join('.'),
        message: err.message,
      }));
    } else if (Array.isArray((error as any).validation)) {
      formattedErrors = (error as any).validation.map((v: any) => ({
        field: v.instancePath || 'body',
        message: v.message,
      }));
    }

    logger.warn({ requestId, errors: formattedErrors }, 'Validation error');
    return reply.status(400).send(errorResponse('VALIDATION_ERROR', error.message || 'Request validation failed', formattedErrors));
  }

  // 2. Prisma Database Errors
  if (error instanceof Prisma.PrismaClientKnownRequestError) {
    switch (error.code) {
      case 'P2002': {
        const target = Array.isArray(error.meta?.target)
          ? (error.meta.target as string[]).join(', ')
          : (error.meta?.target as string) || 'resource';
        logger.warn({ requestId, target }, 'Unique constraint violation');
        return reply.status(409).send(errorResponse('CONFLICT', `A ${target} with this value already exists`));
      }
      case 'P2025': {
        logger.warn({ requestId }, 'Record not found in database');
        return reply.status(404).send(errorResponse('NOT_FOUND', 'Requested resource was not found'));
      }
      default: {
        logger.error({ requestId, prismaCode: error.code, message: error.message }, 'Database error');
        return reply.status(500).send(errorResponse('DATABASE_ERROR', 'A database error occurred'));
      }
    }
  }

  // 3. Fastify Standard HTTP Errors
  if (error.statusCode) {
    logger.warn({ requestId, statusCode: error.statusCode, message: error.message }, 'HTTP error');
    return reply.status(error.statusCode).send(errorResponse(error.code || 'HTTP_ERROR', error.message));
  }

  // 4. Unhandled Internal Server Errors
  logger.error({ requestId, error: error.stack || error.message }, 'Unhandled internal server error');
  return reply.status(500).send(errorResponse('INTERNAL_SERVER_ERROR', 'An unexpected error occurred. Please try again later.'));
}
