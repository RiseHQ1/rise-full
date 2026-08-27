//
//  discover.controller.ts
//  RiseServer
//
//  Controller for Discovery Hub and Universal Search
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { DiscoverService } from './discover.service.js';
import { UniversalSearchQueryInput } from './discover.schema.js';
import { successResponse } from '@/utils/response.js';

export class DiscoverController {
  constructor(private discoverService: DiscoverService) {}

  async getDiscoveryHub(request: FastifyRequest, reply: FastifyReply) {
    const userId = request.user?.userId;
    const hub = await this.discoverService.getDiscoveryHub(userId);
    return reply.status(200).send(successResponse(hub));
  }

  async search(request: FastifyRequest, reply: FastifyReply) {
    const query = request.query as UniversalSearchQueryInput;
    const results = await this.discoverService.search(query);
    return reply.status(200).send(successResponse(results));
  }
}
