//
//  crypto.test.ts
//  RiseServer
//
//  Unit tests for cryptographic helpers
//

import { describe, it, expect } from 'vitest';
import { hashPassword, verifyPassword, generateSecureToken, sha256 } from '@/utils/crypto.js';

describe('Crypto Utilities', () => {
  it('should hash a password with Argon2id and verify correctly', async () => {
    const password = 'super_secret_password_123!';
    const hash = await hashPassword(password);

    expect(hash).toBeDefined();
    expect(hash.startsWith('$argon2')).toBe(true);

    const isValid = await verifyPassword(password, hash);
    expect(isValid).toBe(true);

    const isInvalid = await verifyPassword('wrong_password', hash);
    expect(isInvalid).toBe(false);
  });

  it('should generate secure random hex tokens with specified byte lengths', () => {
    const token32 = generateSecureToken(32);
    expect(token32).toHaveLength(64); // 32 bytes = 64 hex chars

    const token16 = generateSecureToken(16);
    expect(token16).toHaveLength(32);
  });

  it('should calculate accurate SHA-256 digests', () => {
    const digest1 = sha256('rise_token_test');
    const digest2 = sha256('rise_token_test');
    const digest3 = sha256('rise_token_different');

    expect(digest1).toHaveLength(64);
    expect(digest1).toBe(digest2);
    expect(digest1).not.toBe(digest3);
  });
});
