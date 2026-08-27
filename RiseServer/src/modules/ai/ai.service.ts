//
//  ai.service.ts
//  RiseServer
//
//  AI Mindfulness Assistant with Safety Crisis Interceptor and Quota Gating
//

import { redis } from '@/database/redis.js';
import { prisma } from '@/database/prisma.js';
import { AIReflectInput, AIIntentionGenerateInput } from './ai.schema.js';
import { LLMClient } from './llm.client.js';
import { logger } from '@/utils/logger.js';

export interface CrisisHelplineResource {
  isCrisisDetected: true;
  message: string;
  resources: Array<{
    name: string;
    contact: string;
    description: string;
  }>;
}

export class AIService {
  private llmClient = new LLMClient();

  private crisisPatterns: RegExp[] = [
    /\b(kill myself|want to die|commit suicide|end my life|take my own life)\b/i,
    /\b(self[ -]?harm|cutting myself|hurt myself deliberately)\b/i,
    /\b(no reason to live|better off dead|wish i was dead|wish i were dead)\b/i,
    /\b(hang myself|overdose on pills|jump off a bridge)\b/i,
  ];

  /**
   * Check user prompt/entry for crisis indicators and return immediate life-saving resources.
   */
  public checkForCrisis(text: string): CrisisHelplineResource | null {
    const hasCrisisMatch = this.crisisPatterns.some((pattern) => pattern.test(text));

    if (hasCrisisMatch) {
      logger.warn({ snippet: text.substring(0, 40) }, '🚨 Crisis keyword pattern intercepted in AI service');
      return {
        isCrisisDetected: true,
        message:
          "It sounds like you are carrying a lot right now. You are not alone, and there is immediate, confidential support available 24/7.",
        resources: [
          {
            name: '988 Suicide & Crisis Lifeline',
            contact: 'Call or Text 988',
            description: 'Free, confidential support 24/7 across the United States & Canada.',
          },
          {
            name: 'Crisis Text Line',
            contact: 'Text HOME to 741741',
            description: 'Connect with a crisis counselor via SMS 24 hours a day.',
          },
          {
            name: 'The Trevor Project (LGBTQ Youth)',
            contact: 'Call 1-866-488-7386 or Text START to 678-678',
            description: 'Specialized support for LGBTQ young people.',
          },
          {
            name: 'International Helplines',
            contact: 'https://findahelpline.com',
            description: 'Free, confidential support available in 100+ countries.',
          },
        ],
      };
    }

    return null;
  }

  /**
   * Check and increment daily AI usage quota in Redis.
   */
  async checkAndIncrementQuota(userId: string, isPro: boolean): Promise<boolean> {
    if (isPro) return true; // Unlimited for Pro

    try {
      const today = new Date().toISOString().split('T')[0];
      const quotaKey = `ai_quota:${userId}:${today}`;
      const usage = await redis.incr(quotaKey);

      if (usage === 1) {
        await redis.expire(quotaKey, 86400); // 24 hours TTL
      }

      const FREE_TIER_DAILY_LIMIT = 3;
      if (usage > FREE_TIER_DAILY_LIMIT) {
        return false;
      }

      return true;
    } catch (err) {
      logger.warn({ err }, 'Redis quota check fallback — allowing request');
      return true; // Fallback gracefully if Redis is temporarily offline
    }
  }

  /**
   * Generate mindful reflection feedback based on user entry and emotional state.
   */
  async generateReflection(userId: string, isPro: boolean, input: AIReflectInput) {
    // 1. Safety Crisis Interception
    const crisis = this.checkForCrisis(input.entryText);
    if (crisis) {
      return crisis;
    }

    // 2. Quota Check
    const isAllowed = await this.checkAndIncrementQuota(userId, isPro);
    if (!isAllowed) {
      throw {
        statusCode: 429,
        code: 'QUOTA_EXCEEDED',
        message: 'You have reached your free daily AI reflections limit (3/day). Upgrade to Rise Pro for unlimited insights.',
      };
    }

    // 3. Query LLM Provider / Heuristic Engine
    const llmResult = await this.llmClient.generateReflection({
      mood: input.mood,
      category: input.category,
      entryText: input.entryText,
      userPrompt: input.prompt,
    });

    return {
      isCrisisDetected: false,
      ...llmResult,
      timestamp: new Date().toISOString(),
    };
  }

  /**
   * Generate customized daily intentions for morning routines.
   */
  async generateIntention(userId: string, isPro: boolean, input: AIIntentionGenerateInput) {
    const isAllowed = await this.checkAndIncrementQuota(userId, isPro);
    if (!isAllowed) {
      throw {
        statusCode: 429,
        code: 'QUOTA_EXCEEDED',
        message: 'Daily intention limit reached. Upgrade to Rise Pro for unlimited personalized intentions.',
      };
    }

    const intentions = [
      `Today, I choose to protect my peace and focus on what I can control.`,
      `I will meet each moment with patience and give myself grace as I learn.`,
      `My value is not measured by perfection, but by my willingness to keep showing up.`,
      `I approach my day with quiet confidence, calm breath, and steady determination.`,
    ];

    return {
      focusArea: input.focusArea,
      intention: intentions[Math.floor(Math.random() * intentions.length)],
      affirmation: 'I am grounded, capable, and ready for today.',
      suggestedBreathwork: '4-4-4-4 Box Breathing Reset (2 mins)',
    };
  }

  /**
   * Analyze emotional trajectory over the past 7 days for the user.
   */
  async getWeeklyMoodInsights(userId: string) {
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const entries = await prisma.journalEntry.findMany({
      where: {
        userId,
        clientCreatedAt: { gte: sevenDaysAgo },
        isDeleted: false,
      },
      select: { mood: true, clientCreatedAt: true, tags: true },
    });

    const moodCounts: Record<string, number> = {
      GREAT: 0,
      CALM: 0,
      OKAY: 0,
      LOW: 0,
      TIRED: 0,
    };

    entries.forEach((e) => {
      moodCounts[e.mood] = (moodCounts[e.mood] || 0) + 1;
    });

    const total = entries.length;
    const dominantMood = Object.entries(moodCounts).sort((a, b) => b[1] - a[1])[0]?.[0] || 'CALM';

    return {
      totalReflections: total,
      moodBreakdown: moodCounts,
      dominantMood,
      insightSummary:
        total > 0
          ? `Over the last 7 days, your most frequent emotional state was ${dominantMood}. You showed up for yourself ${total} times this week!`
          : `Start recording your daily reflections to unlock personalized weekly emotional insights.`,
    };
  }
}
