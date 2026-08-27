//
//  ai.test.ts
//  RiseServer
//
//  Unit tests for AI Mindfulness Service and Crisis Safety Interceptor
//

import { describe, it, expect } from 'vitest';
import { AIService } from '@/modules/ai/ai.service.js';

describe('AI Service Safety Guardrails', () => {
  const aiService = new AIService();

  it('should detect crisis keywords and immediately return 24/7 hotline resources', () => {
    const crisisInput = "I've been feeling like I want to end my life, everything is too hard.";
    const result = aiService.checkForCrisis(crisisInput);

    expect(result).not.toBeNull();
    expect(result?.isCrisisDetected).toBe(true);
    expect(result?.resources.length).toBeGreaterThan(0);
    expect(result?.resources.some((r) => r.name.includes('988'))).toBe(true);
  });

  it('should not trigger false positives on benign colloquial phrases', () => {
    const benignInput1 = 'I killed that presentation today, felt super confident!';
    const benignInput2 = 'We are killing it at the gym this morning.';
    const benignInput3 = 'Dead tired after a long flight, but happy to be home.';

    expect(aiService.checkForCrisis(benignInput1)).toBeNull();
    expect(aiService.checkForCrisis(benignInput2)).toBeNull();
    expect(aiService.checkForCrisis(benignInput3)).toBeNull();
  });

  it('should return null when no crisis is detected in normal reflections', () => {
    const normalInput = 'Today was a busy day at work. I felt tired but grateful for a quiet evening.';
    const result = aiService.checkForCrisis(normalInput);

    expect(result).toBeNull();
  });
});
