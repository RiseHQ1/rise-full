//
//  env.ts
//  RiseServer
//
//  Strict Zod environment configuration & validation
//

import dotenv from 'dotenv';
import { z } from 'zod';

dotenv.config();

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().default(3000),
  HOST: z.string().default('0.0.0.0'),
  LOG_LEVEL: z.enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace', 'silent']).default('info'),
  API_PREFIX: z.string().default('/api/v1'),

  DATABASE_URL: z.string().min(1, 'DATABASE_URL is required'),
  REDIS_URL: z.string().default('redis://localhost:6379'),

  JWT_ACCESS_SECRET: z.string().default(process.env.JWT_SECRET || '41acb74c8037a05d4a9ad3d5bf1661e332f1de075b5d6ac8f939ecfbcbe40c74'),
  JWT_REFRESH_SECRET: z.string().default(process.env.JWT_REFRESH_SECRET || '8e7a64fb46cde11762d6c3e40f01359d06d9a7cd5c50dc3828ca0e1bd9b583ea'),
  JWT_ACCESS_EXPIRES_IN: z.string().default('15m'),
  JWT_REFRESH_EXPIRES_IN: z.string().default('30d'),

  APPLE_CLIENT_ID: z.string().default('com.riseapp.rise2026'),
  APPLE_TEAM_ID: z.string().optional(),
  APPLE_KEY_ID: z.string().optional(),
  APPLE_PRIVATE_KEY: z.string().optional(),

  REVENUECAT_WEBHOOK_AUTH_KEY: z.string().default('rise_rc_webhook_secret_key_prod_test'),

  RATE_LIMIT_MAX: z.coerce.number().default(100),
  RATE_LIMIT_TIME_WINDOW: z.string().default('1 minute'),
});

const parseEnv = () => {
  const result = envSchema.safeParse(process.env);
  if (!result.success) {
    console.error('❌ Invalid environment variables configuration:', result.error.format());
    process.exit(1);
  }
  return result.data;
};

export const env = parseEnv();
export type Env = z.infer<typeof envSchema>;
