//
//  journal.service.ts
//  RiseServer
//
//  Journal and mindful reflections business logic
//

import { prisma } from '@/database/prisma.js';
import { CreateJournalEntryInput, UpdateJournalEntryInput, JournalQueryInput } from './journal.schema.js';

export class JournalService {
  /**
   * Create or upsert a journal entry.
   */
  async createEntry(userId: string, input: CreateJournalEntryInput) {
    const entry = await prisma.journalEntry.upsert({
      where: {
        userId_syncId: {
          userId,
          syncId: input.syncId,
        },
      },
      update: {
        mood: input.mood,
        prompt: input.prompt,
        encryptedContent: input.encryptedContent,
        iv: input.iv,
        authTag: input.authTag,
        plainTextFallback: input.plainTextFallback,
        tags: input.tags,
        clientUpdatedAt: new Date(input.clientUpdatedAt),
        isDeleted: false,
        version: { increment: 1 },
      },
      create: {
        syncId: input.syncId,
        userId,
        mood: input.mood,
        prompt: input.prompt,
        encryptedContent: input.encryptedContent,
        iv: input.iv,
        authTag: input.authTag,
        plainTextFallback: input.plainTextFallback,
        tags: input.tags,
        clientCreatedAt: new Date(input.clientCreatedAt),
        clientUpdatedAt: new Date(input.clientUpdatedAt),
        version: 1,
      },
    });

    // Update user reflection count & streak
    await prisma.userProgress.upsert({
      where: { userId },
      update: {
        reflectionCount: { increment: 1 },
        lastActiveDate: new Date(),
      },
      create: {
        userId,
        reflectionCount: 1,
        lastActiveDate: new Date(),
      },
    });

    return entry;
  }

  /**
   * List journal entries with pagination and mood/tag filters.
   */
  async listEntries(userId: string, query: JournalQueryInput) {
    const skip = (query.page - 1) * query.limit;

    const where = {
      userId,
      isDeleted: false,
      ...(query.mood && { mood: query.mood }),
      ...(query.tag && { tags: { has: query.tag } }),
    };

    const [entries, total] = await Promise.all([
      prisma.journalEntry.findMany({
        where,
        orderBy: { clientCreatedAt: 'desc' },
        skip,
        take: query.limit,
      }),
      prisma.journalEntry.count({ where }),
    ]);

    return {
      entries,
      total,
      page: query.page,
      limit: query.limit,
      hasMore: skip + entries.length < total,
    };
  }

  /**
   * Fetch a single journal entry by syncId.
   */
  async getEntry(userId: string, syncId: string) {
    const entry = await prisma.journalEntry.findUnique({
      where: { userId_syncId: { userId, syncId } },
    });

    if (!entry || entry.isDeleted) {
      throw { statusCode: 404, code: 'ENTRY_NOT_FOUND', message: 'Journal entry not found' };
    }

    return entry;
  }

  /**
   * Soft-delete a journal entry by syncId.
   */
  async deleteEntry(userId: string, syncId: string) {
    const entry = await prisma.journalEntry.updateMany({
      where: { userId, syncId },
      data: {
        isDeleted: true,
        clientUpdatedAt: new Date(),
        version: { increment: 1 },
      },
    });

    if (entry.count === 0) {
      throw { statusCode: 404, code: 'ENTRY_NOT_FOUND', message: 'Journal entry not found' };
    }

    return { message: 'Journal entry deleted successfully' };
  }

  /**
   * Get rotating time-aware daily reflection prompt.
   */
  async getDailyPrompt() {
    const hour = new Date().getUTCHours();
    let timeOfDay: 'morning' | 'midday' | 'evening' = 'morning';

    if (hour >= 12 && hour < 17) {
      timeOfDay = 'midday';
    } else if (hour >= 17 || hour < 5) {
      timeOfDay = 'evening';
    }

    const promptsByTime = {
      morning: [
        'What is one small intention you want to carry into today?',
        'How can you show up for yourself with patience this morning?',
        'What is one thing within your control that you can focus on today?',
      ],
      midday: [
        'Where can you soften your expectations and pause right now?',
        'What has gone well so far today that you might be overlooking?',
        'Take three deep breaths. What does your mind need most in this moment?',
      ],
      evening: [
        'What made you feel proud, peaceful, or grateful today?',
        'What thought or worry can you consciously release before sleeping?',
        'How did you show strength or kindness to yourself today?',
      ],
    };

    const list = promptsByTime[timeOfDay];
    const prompt = list[Math.floor(Math.random() * list.length)];

    return {
      timeOfDay,
      prompt,
      timestamp: new Date().toISOString(),
    };
  }
}
