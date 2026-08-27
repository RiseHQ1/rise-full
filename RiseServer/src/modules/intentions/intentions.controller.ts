//
//  intentions.controller.ts
//  RiseServer
//
//  Controller for Daily Intentions
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { IntentionsService } from './intentions.service.js';
import { CreateIntentionInput, ToggleIntentionInput } from './intentions.schema.js';
import { successResponse } from '@/utils/response.js';

export class IntentionsController {
  constructor(private intentionsService: IntentionsService) {}

  async getSuggestions(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user?.userId;
    const suggestions = await this.intentionsService.getSuggestions(userId);
    return reply.status(200).send(successResponse(suggestions));
  }

  async getIntentionByDate(request: FastifyRequest, reply: FastifyReply) {
    const query = request.query as { date?: string };
    const date = query?.date || new Date().toISOString().slice(0, 10);
    const intention = await this.intentionsService.getIntentionByDate(request.user.userId, date);
    return reply.status(200).send(successResponse(intention));
  }

  async createOrUpdate(request: FastifyRequest, reply: FastifyReply) {
    const body = request.body as CreateIntentionInput;
    const intention = await this.intentionsService.createOrUpdateIntention(
      request.user.userId,
      body
    );
    return reply.status(200).send(successResponse(intention));
  }

  async toggleCompletion(request: FastifyRequest, reply: FastifyReply) {
    const { syncId } = request.params as { syncId: string };
    const body = request.body as ToggleIntentionInput;
    const updated = await this.intentionsService.toggleIntentionCompletion(
      request.user.userId,
      syncId,
      body
    );
    return reply.status(200).send(successResponse(updated));
  }
}
