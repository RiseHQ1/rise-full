//
//  journal.schema.ts
//  RiseServer
//
//  Zod validation schemas for journal entries and reflections
//

import { z } from 'zod';

export const moodEnum = z.enum(['GREAT', 'CALM', 'OKAY', 'LOW', 'TIRED']);

export const createJournalEntrySchema = z.object({
  syncId: z.string().uuid(),
  mood: moodEnum.default('GREAT'),
  prompt: z.string().optional().nullable(),
  encryptedContent: z.string().optional().nullable(),
  iv: z.string().optional().nullable(),
  authTag: z.string().optional().nullable(),
  plainTextFallback: z.string().optional().nullable(),
  tags: z.array(z.string()).default([]),
  clientCreatedAt: z.string().datetime({ offset: true }),
  clientUpdatedAt: z.string().datetime({ offset: true }),
});

export const updateJournalEntrySchema = z.object({
  mood: moodEnum.optional(),
  prompt: z.string().optional().nullable(),
  encryptedContent: z.string().optional().nullable(),
  iv: z.string().optional().nullable(),
  authTag: z.string().optional().nullable(),
  plainTextFallback: z.string().optional().nullable(),
  tags: z.array(z.string()).optional(),
  clientUpdatedAt: z.string().datetime({ offset: true }),
});

export const journalQuerySchema = z.object({
  mood: moodEnum.optional(),
  tag: z.string().optional(),
  limit: z.coerce.number().int().min(1).max(100).default(20),
  page: z.coerce.number().int().min(1).default(1),
});

export type CreateJournalEntryInput = z.infer<typeof createJournalEntrySchema>;
export type UpdateJournalEntryInput = z.infer<typeof updateJournalEntrySchema>;
export type JournalQueryInput = z.infer<typeof journalQuerySchema>;
