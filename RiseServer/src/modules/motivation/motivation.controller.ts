//
//  motivation.controller.ts
//  RiseServer
//
//  Motivation & Affirmations CMS controller
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { MotivationService } from './motivation.service.js';
import { QuoteQueryInput, DailyThoughtQueryInput, AffirmationQueryInput } from './motivation.schema.js';
import { successResponse } from '@/utils/response.js';

export class MotivationController {
  constructor(private motivationService: MotivationService) {}

  async getDailyThought(request: FastifyRequest<{ Querystring: DailyThoughtQueryInput }>, reply: FastifyReply) {
    const thought = await this.motivationService.getDailyThought(request.query.dayOfYear);
    return reply.status(200).send(successResponse(thought));
  }

  async getDailyAffirmation(request: FastifyRequest<{ Querystring: DailyThoughtQueryInput }>, reply: FastifyReply) {
    const affirmation = await this.motivationService.getDailyAffirmation(request.query.dayOfYear);
    return reply.status(200).send(successResponse(affirmation));
  }

  async getCatalog(request: FastifyRequest<{ Querystring: QuoteQueryInput }>, reply: FastifyReply) {
    const result = await this.motivationService.getCatalog(request.query);
    return reply.status(200).send(
      successResponse(result.quotes, {
        total: result.total,
        page: result.page,
        limit: result.limit,
        hasMore: result.hasMore,
      })
    );
  }

  async getAffirmations(request: FastifyRequest<{ Querystring: AffirmationQueryInput }>, reply: FastifyReply) {
    const result = await this.motivationService.getAffirmations(request.query);
    return reply.status(200).send(
      successResponse(result.affirmations, {
        total: result.total,
        page: result.page,
        limit: result.limit,
        hasMore: result.hasMore,
      })
    );
  }

  async getCategories(_request: FastifyRequest, reply: FastifyReply) {
    const categories = await this.motivationService.getCategories();
    return reply.status(200).send(successResponse(categories));
  }
}
