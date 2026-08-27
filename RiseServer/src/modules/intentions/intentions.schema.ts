//
//  intentions.schema.ts
//  RiseServer
//
//  Zod validation schemas for Daily Intentions
//

import { z } from 'zod';

export const createIntentionSchema = z.object({
  syncId: z.string().uuid(),
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/, 'Date format must be YYYY-MM-DD'),
  text: z.string().min(1).max(500),
  category: z.string().default('Focus'),
  isCustom: z.boolean().default(false),
  isCompleted: z.boolean().default(false),
  clientCreatedAt: z.string().datetime({ offset: true }),
  clientUpdatedAt: z.string().datetime({ offset: true }),
});

export const toggleIntentionSchema = z.object({
  isCompleted: z.boolean(),
  clientUpdatedAt: z.string().datetime({ offset: true }),
});

export const intentionQuerySchema = z.object({
  date: z.string().regex(/^\d{4}-\d{2}-\d{2}$/).optional(),
  category: z.string().optional(),
});

export type CreateIntentionInput = z.infer<typeof createIntentionSchema>;
export type ToggleIntentionInput = z.infer<typeof toggleIntentionSchema>;
export type IntentionQueryInput = z.infer<typeof intentionQuerySchema>;
