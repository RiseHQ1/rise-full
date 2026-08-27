//
//  admin.controller.ts
//  RiseServer
//
//  Administrative request controllers for CMS, Packs Studio, Users & Metrics
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { AdminService } from './admin.service.js';
import {
  CreateAdminQuoteInput,
  UpdateAdminQuoteInput,
  ListQuotesAdminQueryInput,
  CreateAdminPackInput,
  UpdateAdminPackInput,
  CreateAdminAffirmationInput,
  UpdateAdminAffirmationInput,
  ListAffirmationsAdminQueryInput,
  ListUsersAdminQueryInput,
  UpdateUserSubscriptionAdminInput,
  BroadcastPushInput,
} from './admin.schema.js';
import { successResponse } from '@/utils/response.js';

export class AdminController {
  constructor(private adminService: AdminService) {}

  // ==========================================
  // Platform Metrics
  // ==========================================

  async getPlatformSummary(request: FastifyRequest, reply: FastifyReply) {
    const summary = await this.adminService.getPlatformSummary();
    return reply.status(200).send(successResponse(summary));
  }

  // ==========================================
  // Quotes CMS
  // ==========================================

  async listQuotes(request: FastifyRequest, reply: FastifyReply) {
    const query = request.query as ListQuotesAdminQueryInput;
    const result = await this.adminService.listQuotes(query);
    return reply.status(200).send(successResponse(result.quotes, {
      total: result.total,
      page: result.page,
      limit: result.limit,
      totalPages: result.totalPages,
    }));
  }

  async createQuote(request: FastifyRequest, reply: FastifyReply) {
    const body = request.body as CreateAdminQuoteInput;
    const quote = await this.adminService.createQuote(body);
    return reply.status(201).send(successResponse(quote));
  }

  async updateQuote(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const body = request.body as UpdateAdminQuoteInput;
    const quote = await this.adminService.updateQuote(id, body);
    return reply.status(200).send(successResponse(quote));
  }

  async deleteQuote(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const result = await this.adminService.deleteQuote(id);
    return reply.status(200).send(successResponse(result));
  }

  // ==========================================
  // Packs Studio
  // ==========================================

  async listPacks(request: FastifyRequest, reply: FastifyReply) {
    const packs = await this.adminService.listPacks();
    return reply.status(200).send(successResponse(packs));
  }

  async getPackById(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const pack = await this.adminService.getPackById(id);
    return reply.status(200).send(successResponse(pack));
  }

  async createPack(request: FastifyRequest, reply: FastifyReply) {
    const body = request.body as CreateAdminPackInput;
    const pack = await this.adminService.createPack(body);
    return reply.status(201).send(successResponse(pack));
  }

  async updatePack(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const body = request.body as UpdateAdminPackInput;
    const pack = await this.adminService.updatePack(id, body);
    return reply.status(200).send(successResponse(pack));
  }

  async deletePack(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const result = await this.adminService.deletePack(id);
    return reply.status(200).send(successResponse(result));
  }

  // ==========================================
  // Affirmations CMS
  // ==========================================

  async listAffirmations(request: FastifyRequest, reply: FastifyReply) {
    const query = request.query as ListAffirmationsAdminQueryInput;
    const result = await this.adminService.listAffirmations(query);
    return reply.status(200).send(successResponse(result.affirmations, {
      total: result.total,
      page: result.page,
      limit: result.limit,
      totalPages: result.totalPages,
    }));
  }

  async createAffirmation(request: FastifyRequest, reply: FastifyReply) {
    const body = request.body as CreateAdminAffirmationInput;
    const affirmation = await this.adminService.createAffirmation(body);
    return reply.status(201).send(successResponse(affirmation));
  }

  async updateAffirmation(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const body = request.body as UpdateAdminAffirmationInput;
    const affirmation = await this.adminService.updateAffirmation(id, body);
    return reply.status(200).send(successResponse(affirmation));
  }

  async deleteAffirmation(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const result = await this.adminService.deleteAffirmation(id);
    return reply.status(200).send(successResponse(result));
  }

  // ==========================================
  // User Oversight
  // ==========================================

  async listUsers(request: FastifyRequest, reply: FastifyReply) {
    const query = request.query as ListUsersAdminQueryInput;
    const result = await this.adminService.listUsers(query);
    return reply.status(200).send(successResponse(result.users, {
      total: result.total,
      page: result.page,
      limit: result.limit,
      totalPages: result.totalPages,
    }));
  }

  async updateUserSubscription(request: FastifyRequest, reply: FastifyReply) {
    const { id } = request.params as { id: string };
    const body = request.body as UpdateUserSubscriptionAdminInput;
    const updated = await this.adminService.updateUserSubscription(id, body);
    return reply.status(200).send(successResponse(updated));
  }

  // ==========================================
  // Push Broadcaster
  // ==========================================

  async broadcastPush(request: FastifyRequest, reply: FastifyReply) {
    const body = request.body as BroadcastPushInput;
    const result = await this.adminService.broadcastNotification(body);
    return reply.status(200).send(successResponse(result));
  }
}
