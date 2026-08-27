//
//  user.schema.ts
//  RiseServer
//
//  Zod validation schemas for user profile, focus areas, and preferences
//

import { z } from 'zod';

export const updateProfileSchema = z.object({
  name: z.string().min(1).max(50).optional(),
  avatarUrl: z.preprocess((val) => (val === '' ? null : val), z.string().url().optional().nullable()),
  focusAreas: z.array(z.string()).optional(),
  onboardingComplete: z.boolean().optional(),
  timeZone: z.string().min(1).optional(),
  morningBoostTime: z.string().regex(/^([01]\d|2[0-3]):([0-5]\d)$/, 'Format must be HH:MM').optional(),
  eveningReflectionTime: z.string().regex(/^([01]\d|2[0-3]):([0-5]\d)$/, 'Format must be HH:MM').optional(),
  focusDurationMinutes: z.number().int().min(5).max(120).optional(),
  motivationStyle: z.string().min(1).max(50).optional(),
  notificationsEnabled: z.boolean().optional(),
});

export const changePasswordSchema = z.object({
  currentPassword: z.string().min(1, 'Current password is required'),
  newPassword: z.string().min(8, 'New password must be at least 8 characters long'),
});

export type UpdateProfileInput = z.infer<typeof updateProfileSchema>;
export type ChangePasswordInput = z.infer<typeof changePasswordSchema>;
