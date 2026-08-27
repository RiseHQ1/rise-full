//
//  journal.controller.ts
//  RiseServer
//
//  Journal request handler
//

import { FastifyReply, FastifyRequest } from 'fastify';
import { JournalService } from './journal.service.js';
import { CreateJournalEntryInput, JournalQueryInput } from './journal.schema.js';
import { successResponse } from '@/utils/response.js';

export class JournalController {
  constructor(private journalService: JournalService) {}

  async createEntry(request: FastifyRequest<{ Body: CreateJournalEntryInput }>, reply: FastifyReply) {
    const entry = await this.journalService.createEntry(request.user.userId, request.body);
    return reply.status(201).send(successResponse(entry));
  }

  async listEntries(request: FastifyRequest<{ Querystring: JournalQueryInput }>, reply: FastifyReply) {
    const result = await this.journalService.listEntries(request.user.userId, request.query);
    return reply.status(200).send(
      successResponse(result.entries, {
        total: result.total,
        page: result.page,
        limit: result.limit,
        hasMore: result.hasMore,
      })
    );
  }

  async getEntry(request: FastifyRequest<{ Params: { syncId: string } }>, reply: FastifyReply) {
    const entry = await this.journalService.getEntry(request.user.userId, request.params.syncId);
    return reply.status(200).send(successResponse(entry));
  }

  async deleteEntry(request: FastifyRequest<{ Params: { syncId: string } }>, reply: FastifyReply) {
    const result = await this.journalService.deleteEntry(request.user.userId, request.params.syncId);
    return reply.status(200).send(successResponse(result));
  }

  async getDailyPrompt(_request: FastifyRequest, reply: FastifyReply) {
    const result = await this.journalService.getDailyPrompt();
    return reply.status(200).send(successResponse(result));
  }
}
