//
//  sync.schema.ts
//  RiseServer
//
//  Zod validation schemas for offline-first delta synchronization
//

import { z } from 'zod';
import { moodEnum } from '../journal/journal.schema.js';

const syncJournalItemSchema = z.object({
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
  isDeleted: z.boolean().default(false),
  version: z.number().int().default(1),
});

const syncSavedContentItemSchema = z.object({
  syncId: z.string().uuid(),
  title: z.string().min(1),
  subtitle: z.string().optional().nullable(),
  category: z.string().default('Quote'),
  assetName: z.string().default('onboarding_motivation_bg'),
  isFavorite: z.boolean().default(true),
  clientUpdatedAt: z.string().datetime({ offset: true }),
  isDeleted: z.boolean().default(false),
  version: z.number().int().default(1),
});

const syncIntentionItemSchema = z.object({
  syncId: z.string().uuid(),
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/),
  text: z.string().min(1),
  category: z.string().default('Focus'),
  isCustom: z.boolean().default(false),
  isCompleted: z.boolean().default(false),
  completedAt: z.string().datetime({ offset: true }).optional().nullable(),
  clientCreatedAt: z.string().datetime({ offset: true }),
  clientUpdatedAt: z.string().datetime({ offset: true }),
  isDeleted: z.boolean().default(false),
  version: z.number().int().default(1),
});

const syncProgressSchema = z.object({
  currentStreak: z.number().int().min(0).optional(),
  bestStreak: z.number().int().min(0).optional(),
  mindfulMinutes: z.number().int().min(0).optional(),
  reflectionCount: z.number().int().min(0).optional(),
  focusCount: z.number().int().min(0).optional(),
  weeklyActivity: z.record(z.any()).optional(),
});

export const deltaSyncSchema = z.object({
  lastSyncedAt: z.string().datetime({ offset: true }).optional().nullable(),
  journals: z.array(syncJournalItemSchema).default([]),
  savedItems: z.array(syncSavedContentItemSchema).default([]),
  intentions: z.array(syncIntentionItemSchema).default([]),
  progress: syncProgressSchema.optional(),
});

export type DeltaSyncInput = z.infer<typeof deltaSyncSchema>;
export type SyncJournalItem = z.infer<typeof syncJournalItemSchema>;
export type SyncSavedContentItem = z.infer<typeof syncSavedContentItemSchema>;
export type SyncIntentionItem = z.infer<typeof syncIntentionItemSchema>;
