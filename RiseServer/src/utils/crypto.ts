//
//  crypto.ts
//  RiseServer
//
//  Cryptographic utilities (Argon2id hashing, secure token generation)
//

import * as argon2 from 'argon2';
import crypto from 'node:crypto';
import { APP_CONSTANTS } from '@/config/constants.js';

/**
 * Hash a plain text password using Argon2id.
 */
export async function hashPassword(password: string): Promise<string> {
  return argon2.hash(password, {
    type: argon2.argon2id,
    memoryCost: APP_CONSTANTS.ARGON2_OPTIONS.memoryCost,
    timeCost: APP_CONSTANTS.ARGON2_OPTIONS.timeCost,
    parallelism: APP_CONSTANTS.ARGON2_OPTIONS.parallelism,
  });
}

/**
 * Verify a plain text password against an Argon2id hash.
 */
export async function verifyPassword(password: string, hash: string): Promise<boolean> {
  try {
    return await argon2.verify(hash, password);
  } catch {
    return false;
  }
}

/**
 * Generate a cryptographically secure random hex token.
 */
export function generateSecureToken(bytes: number = 32): string {
  return crypto.randomBytes(bytes).toString('hex');
}

/**
 * Create a SHA-256 hash of a string (useful for hashing refresh tokens before DB storage).
 */
export function sha256(data: string): string {
  return crypto.createHash('sha256').update(data).digest('hex');
}
