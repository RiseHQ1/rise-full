//
//  response.test.ts
//  RiseServer
//
//  Unit tests for RFC 7807 response formatters
//

import { describe, it, expect } from 'vitest';
import { successResponse, errorResponse } from '@/utils/response.js';

describe('Response Utilities', () => {
  it('should format success response with data and timestamp', () => {
    const data = { user: 'John', streak: 5 };
    const response = successResponse(data, { total: 1 });

    expect(response.success).toBe(true);
    expect(response.data).toEqual(data);
    expect(response.meta?.total).toBe(1);
    expect(response.meta?.timestamp).toBeDefined();
  });

  it('should format error response with RFC 7807 problem details', () => {
    const response = errorResponse('INVALID_INPUT', 'The field is required', [{ field: 'email' }]);

    expect(response.success).toBe(false);
    expect(response.error.code).toBe('INVALID_INPUT');
    expect(response.error.message).toBe('The field is required');
    expect(response.error.details).toEqual([{ field: 'email' }]);
    expect(response.error.timestamp).toBeDefined();
  });
});
