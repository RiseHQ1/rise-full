//
//  discover.service.ts
//  RiseServer
//
//  Business logic for Discovery Hub and Unified Search with DB cold-start resilience
//

import { prisma } from '@/database/prisma.js';
import { MotivationService } from '@/modules/motivation/motivation.service.js';
import { PacksService } from '@/modules/packs/packs.service.js';
import { UniversalSearchQueryInput } from './discover.schema.js';

export class DiscoverService {
  private motivationService = new MotivationService();
  private packsService = new PacksService();

  /**
   * Get consolidated Discovery Hub data feed.
   */
  async getDiscoveryHub(userId?: string) {
    const [dailyThought, dailyAffirmation, packs, categories] = await Promise.all([
      this.motivationService.getDailyThought(),
      this.motivationService.getDailyAffirmation(),
      this.packsService.listPacks(userId),
      this.motivationService.getCategories(),
    ]);

    const breathingResets = [
      {
        id: 'box-breathing',
        title: 'Box Breathing (4-4-4-4)',
        subtitle: 'Settle tension & regain composure',
        durationMinutes: 3,
        pattern: { inhale: 4, holdIn: 4, exhale: 4, holdOut: 4 },
        systemIcon: 'wind',
      },
      {
        id: 'deep-calm',
        title: '4-7-8 Deep Calm',
        subtitle: 'Calm the central nervous system',
        durationMinutes: 5,
        pattern: { inhale: 4, holdIn: 7, exhale: 8, holdOut: 0 },
        systemIcon: 'moon.stars.fill',
      },
      {
        id: 'morning-energize',
        title: 'Morning Energize',
        subtitle: 'Awaken your body & stimulate mental clarity',
        durationMinutes: 3,
        pattern: { inhale: 5, holdIn: 2, exhale: 5, holdOut: 0 },
        systemIcon: 'sun.max.fill',
      },
    ];

    return {
      dailyThought,
      dailyAffirmation,
      featuredPacks: packs.slice(0, 4),
      allPacks: packs,
      categories,
      breathingResets,
    };
  }

  /**
   * Universal search across quotes, affirmations, and packs.
   */
  async search(query: UniversalSearchQueryInput) {
    const searchTerm = query.q ? query.q.trim() : '';
    const limit = query.limit;

    if (!searchTerm) {
      return {
        query: '',
        totalMatches: 0,
        quotes: [],
        affirmations: [],
        packs: [],
      };
    }

    try {
      const [quotes, affirmations, packs] = await Promise.all([
        prisma.motivationQuote.findMany({
          where: {
            OR: [
              { quote: { contains: searchTerm, mode: 'insensitive' } },
              { author: { contains: searchTerm, mode: 'insensitive' } },
              { category: { contains: searchTerm, mode: 'insensitive' } },
              { tags: { has: searchTerm.toLowerCase() } },
            ],
            ...(query.category && { category: { equals: query.category, mode: 'insensitive' } }),
          },
          take: limit,
        }),
        prisma.affirmation.findMany({
          where: {
            OR: [
              { text: { contains: searchTerm, mode: 'insensitive' } },
              { category: { contains: searchTerm, mode: 'insensitive' } },
              { tags: { has: searchTerm.toLowerCase() } },
            ],
            ...(query.category && { category: { equals: query.category, mode: 'insensitive' } }),
          },
          take: limit,
        }),
        prisma.risePack.findMany({
          where: {
            isPublished: true,
            OR: [
              { title: { contains: searchTerm, mode: 'insensitive' } },
              { subtitle: { contains: searchTerm, mode: 'insensitive' } },
              { description: { contains: searchTerm, mode: 'insensitive' } },
              { category: { contains: searchTerm, mode: 'insensitive' } },
            ],
            ...(query.category && { category: { equals: query.category, mode: 'insensitive' } }),
          },
          take: 5,
        }),
      ]);

      const totalMatches = quotes.length + affirmations.length + packs.length;

      return {
        query: searchTerm,
        totalMatches,
        quotes,
        affirmations,
        packs,
      };
    } catch {
      // Fallback search response
      const allFallbackPacks = await this.packsService.listPacks();
      const matchedPacks = allFallbackPacks.filter((p) =>
        p.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        p.category.toLowerCase().includes(searchTerm.toLowerCase())
      );

      return {
        query: searchTerm,
        totalMatches: matchedPacks.length,
        quotes: [],
        affirmations: [],
        packs: matchedPacks,
      };
    }
  }
}
