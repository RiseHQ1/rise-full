//
//  ai.schema.ts
//  RiseServer
//
//  Zod validation schemas for AI mindfulness assistant and reflection generation
//

import { z } from 'zod';
import { moodEnum } from '../journal/journal.schema.js';

export const aiReflectSchema = z.object({
  mood: moodEnum.default('GREAT'),
  prompt: z.string().optional(),
  entryText: z.string().min(1, 'Journal text is required for reflection insights').max(3000),
  category: z.string().default('Mindset'),
});

export const aiIntentionGenerateSchema = z.object({
  focusArea: z.string().min(1).default('Calm & Focus'),
  currentFeeling: z.string().optional(),
});

export type AIReflectInput = z.infer<typeof aiReflectSchema>;
export type AIIntentionGenerateInput = z.infer<typeof aiIntentionGenerateSchema>;
