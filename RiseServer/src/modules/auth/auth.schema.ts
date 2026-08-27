//
//  auth.schema.ts
//  RiseServer
//
//  Zod validation schemas for authentication endpoints
//

import { z } from 'zod';

export const registerSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(8, 'Password must be at least 8 characters long'),
  name: z.string().min(1, 'Name is required').default('Friend'),
});

export const loginSchema = z.object({
  email: z.string().email('Invalid email address'),
  password: z.string().min(1, 'Password is required'),
});

export const appleAuthSchema = z.object({
  identityToken: z.string().min(1, 'Apple identity token is required'),
  appleUserId: z.string().min(1, 'Apple User ID is required'),
  email: z.preprocess((val) => (val === '' || val === null ? undefined : val), z.string().email().optional()),
  name: z.preprocess((val) => (val === '' || val === null ? undefined : val), z.string().optional()),
});

export const refreshTokenSchema = z.object({
  refreshToken: z.string().min(1, 'Refresh token is required'),
});

export const forgotPasswordSchema = z.object({
  email: z.string().email('Invalid email address'),
});

export const resetPasswordSchema = z.object({
  token: z.string().min(1, 'Reset token is required'),
  newPassword: z.string().min(8, 'Password must be at least 8 characters long'),
});

export const appleWebhookSchema = z.object({
  payload: z.string().min(1, 'Apple signed JWT payload is required'),
});

export const sendOtpSchema = z.object({
  email: z.string().email('Invalid email address'),
  name: z.string().optional(),
});

export const verifyOtpSchema = z.object({
  email: z.string().email('Invalid email address'),
  code: z.string().length(6, 'Verification code must be 6 digits'),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type AppleAuthInput = z.infer<typeof appleAuthSchema>;
export type RefreshTokenInput = z.infer<typeof refreshTokenSchema>;
export type ForgotPasswordInput = z.infer<typeof forgotPasswordSchema>;
export type ResetPasswordInput = z.infer<typeof resetPasswordSchema>;
export type AppleWebhookInput = z.infer<typeof appleWebhookSchema>;
export type SendOtpInput = z.infer<typeof sendOtpSchema>;
export type VerifyOtpInput = z.infer<typeof verifyOtpSchema>;
