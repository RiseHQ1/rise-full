//
//  packs.controller.ts
//  RiseServer
//
//  Controller for Rise Packs endpoints
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { PacksService } from './packs.service.js';
import { PackQueryInput, UpdatePackProgressInput } from './packs.schema.js';
import { successResponse } from '@/utils/response.js';

export class PacksController {
  constructor(private packsService: PacksService) {}

  async listPacks(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user?.userId;
    const query = request.query as PackQueryInput;
    const packs = await this.packsService.listPacks(userId, query);
    return reply.status(200).send(successResponse(packs));
  }

  async getPackBySlug(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user?.userId;
    const { slug } = request.params as { slug: string };
    const pack = await this.packsService.getPackBySlug(slug, userId);
    return reply.status(200).send(successResponse(pack));
  }

  async updateProgress(request: FastifyRequest, reply: FastifyReply) {
    const { slug } = request.params as { slug: string };
    const body = request.body as UpdatePackProgressInput;
    const progress = await this.packsService.updateProgress(
      request.user.userId,
      slug,
      body
    );
    return reply.status(200).send(successResponse(progress));
  }

  async getUserPackProgress(request: FastifyRequest, reply: FastifyReply) {
    const progressList = await this.packsService.getUserPackProgress(request.user.userId);
    return reply.status(200).send(successResponse(progressList));
  }
}
