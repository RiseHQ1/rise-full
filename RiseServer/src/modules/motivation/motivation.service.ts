//
//  motivation.service.ts
//  RiseServer
//
//  Motivation & Affirmations CMS content delivery with Redis caching & DB cold-start resilience
//

import { prisma } from '@/database/prisma.js';
import { redis } from '@/database/redis.js';
import { Prisma } from '@prisma/client';
import { QuoteQueryInput, AffirmationQueryInput } from './motivation.schema.js';

export class MotivationService {
  /**
   * Get today's thought of the day (cached in Redis for fast delivery).
   */
  async getDailyThought(dayOfYear?: number) {
    const currentDay = dayOfYear ?? this.getCurrentDayOfYear();
    const cacheKey = `daily_thought:${currentDay}`;

    try {
      const cached = await redis.get(cacheKey);
      if (cached) {
        return JSON.parse(cached);
      }
    } catch {
      // Redis offline resilience
    }

    try {
      let thought = await prisma.motivationQuote.findFirst({
        where: { dayOfYear: currentDay },
      });

      if (!thought) {
        thought = await prisma.motivationQuote.findFirst({
          where: { isFeatured: true },
        });
      }

      if (!thought) {
        thought = await prisma.motivationQuote.findFirst({
          orderBy: { createdAt: 'desc' },
        });
      }

      if (thought) {
        await redis.set(cacheKey, JSON.stringify(thought), 'EX', 3600 * 6).catch(() => null);
        return thought;
      }
    } catch {
      // DB cold start resilience
    }

    return {
      id: 'default-daily-thought',
      quote: 'You have power over your mind - not outside events. Realize this, and you will find strength.',
      author: 'Marcus Aurelius',
      category: 'Stoicism',
      tags: ['stoicism', 'strength', 'mind'],
      assetName: 'onboarding_motivation_bg',
      dayOfYear: currentDay,
      isFeatured: true,
    };
  }

  /**
   * Get today's daily affirmation (cached in Redis for fast delivery).
   */
  async getDailyAffirmation(dayOfYear?: number) {
    const currentDay = dayOfYear ?? this.getCurrentDayOfYear();
    const cacheKey = `daily_affirmation:${currentDay}`;

    try {
      const cached = await redis.get(cacheKey);
      if (cached) {
        return JSON.parse(cached);
      }
    } catch {
      // Redis offline resilience
    }

    try {
      let affirmation = await prisma.affirmation.findFirst({
        where: { dayOfYear: currentDay },
      });

      if (!affirmation) {
        affirmation = await prisma.affirmation.findFirst({
          orderBy: { createdAt: 'asc' },
        });
      }

      if (affirmation) {
        await redis.set(cacheKey, JSON.stringify(affirmation), 'EX', 3600 * 6).catch(() => null);
        return affirmation;
      }
    } catch {
      // DB cold start resilience
    }

    return {
      id: 'default-daily-affirmation',
      text: 'I am grounded, capable, and ready to meet today with calm strength.',
      category: 'Mindfulness',
      tags: ['mindfulness', 'calm', 'strength'],
      accessLevel: 'FREE',
      dayOfYear: currentDay,
      assetName: 'onboarding_motivation_bg',
    };
  }

  /**
   * List motivation catalog quotes with search, category filtering, and pagination.
   */
  async getCatalog(query: QuoteQueryInput) {
    const skip = (query.page - 1) * query.limit;

    try {
      const where: Prisma.MotivationQuoteWhereInput = {};
      if (query.category) {
        where.category = { equals: query.category, mode: 'insensitive' };
      }
      if (query.search) {
        where.OR = [
          { quote: { contains: query.search, mode: 'insensitive' } },
          { author: { contains: query.search, mode: 'insensitive' } },
          { tags: { has: query.search.toLowerCase() } },
        ];
      }

      const [quotes, total] = await Promise.all([
        prisma.motivationQuote.findMany({
          where,
          skip,
          take: query.limit,
          orderBy: { createdAt: 'desc' },
        }),
        prisma.motivationQuote.count({ where }),
      ]);

      return {
        quotes,
        total,
        page: query.page,
        limit: query.limit,
        hasMore: skip + quotes.length < total,
      };
    } catch {
      return {
        quotes: [
          {
            id: 'fallback-quote-1',
            quote: 'The journey of a thousand miles begins with a single step.',
            author: 'Lao Tzu',
            category: 'Growth',
            tags: ['growth', 'action'],
            assetName: 'onboarding_motivation_bg',
          },
        ],
        total: 1,
        page: query.page,
        limit: query.limit,
        hasMore: false,
      };
    }
  }

  /**
   * List curated affirmations catalog with category and tag filtering.
   */
  async getAffirmations(query: AffirmationQueryInput) {
    const skip = (query.page - 1) * query.limit;

    try {
      const where: Prisma.AffirmationWhereInput = {};
      if (query.category) {
        where.category = { equals: query.category, mode: 'insensitive' };
      }
      if (query.accessLevel) {
        where.accessLevel = query.accessLevel;
      }
      if (query.tag) {
        where.tags = { has: query.tag.toLowerCase() };
      }
      if (query.search) {
        where.OR = [
          { text: { contains: query.search, mode: 'insensitive' } },
          { category: { contains: query.search, mode: 'insensitive' } },
          { tags: { has: query.search.toLowerCase() } },
        ];
      }

      const [affirmations, total] = await Promise.all([
        prisma.affirmation.findMany({
          where,
          skip,
          take: query.limit,
          orderBy: { createdAt: 'desc' },
        }),
        prisma.affirmation.count({ where }),
      ]);

      return {
        affirmations,
        total,
        page: query.page,
        limit: query.limit,
        hasMore: skip + affirmations.length < total,
      };
    } catch {
      return {
        affirmations: [
          {
            id: 'fallback-aff-1',
            text: 'I am grounded in this moment, and I have everything I need to begin.',
            category: 'Mindfulness',
            tags: ['mindfulness', 'calm'],
            accessLevel: 'FREE',
            assetName: 'onboarding_motivation_bg',
          },
        ],
        total: 1,
        page: query.page,
        limit: query.limit,
        hasMore: false,
      };
    }
  }

  /**
   * Get list of unique categories available in the database.
   */
  async getCategories() {
    try {
      const categories = await prisma.motivationQuote.findMany({
        select: { category: true },
        distinct: ['category'],
      });

      const list = categories.map((c) => c.category).filter(Boolean);
      if (list.length > 0) return list;
    } catch {
      // Fallback
    }

    return [
      'Stoicism',
      'Discipline',
      'Mindfulness',
      'Resilience',
      'Gratitude',
      'Focus',
      'Inner Peace',
      'Growth',
      'Courage',
      'Confidence',
      'Self-Love',
      'Calm',
    ];
  }

  /**
   * Helper to calculate day of year (1-366) with UTC precision (DST-immune).
   */
  private getCurrentDayOfYear(): number {
    const now = new Date();
    const start = Date.UTC(now.getUTCFullYear(), 0, 1);
    const current = Date.UTC(now.getUTCFullYear(), now.getUTCMonth(), now.getUTCDate());
    const oneDay = 1000 * 60 * 60 * 24;
    return Math.floor((current - start) / oneDay) + 1;
  }
}
