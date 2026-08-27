//
//  ai.controller.ts
//  RiseServer
//
//  AI Mindfulness Assistant request controller
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { AIService } from './ai.service.js';
import { AIReflectInput, AIIntentionGenerateInput } from './ai.schema.js';
import { successResponse } from '@/utils/response.js';

export class AIController {
  constructor(private aiService: AIService) {}

  async generateReflection(request: FastifyRequest<{ Body: AIReflectInput }>, reply: FastifyReply) {
    const isPro = request.user.subscriptionTier !== 'FREE';
    const result = await this.aiService.generateReflection(request.user.userId, isPro, request.body);
    return reply.status(200).send(successResponse(result));
  }

  async generateIntention(request: FastifyRequest<{ Body: AIIntentionGenerateInput }>, reply: FastifyReply) {
    const isPro = request.user.subscriptionTier !== 'FREE';
    const result = await this.aiService.generateIntention(request.user.userId, isPro, request.body);
    return reply.status(200).send(successResponse(result));
  }

  async getWeeklyInsights(request: FastifyRequest, reply: FastifyReply) {
    const insights = await this.aiService.getWeeklyMoodInsights(request.user.userId);
    return reply.status(200).send(successResponse(insights));
  }
}
