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
    const [dailyThought, dailyAffirmation] = await Promise.all([
      this.motivationService.getDailyThought(),
      this.motivationService.getDailyAffirmation(),
    ]);

    const categories = [
      {
        id: 'cat-motivation',
        title: 'Motivation',
        count: 128,
        backgroundAssetName: 'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=600&q=80',
      },
      {
        id: 'cat-discipline',
        title: 'Discipline',
        count: 96,
        backgroundAssetName: 'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=600&q=80',
      },
      {
        id: 'cat-focus',
        title: 'Focus',
        count: 84,
        backgroundAssetName: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=600&q=80',
      },
      {
        id: 'cat-selfgrowth',
        title: 'Self Growth',
        count: 112,
        backgroundAssetName: 'https://images.unsplash.com/photo-1416879595882-3373a0480b5b?auto=format&fit=crop&w=600&q=80',
      },
      {
        id: 'cat-mindset',
        title: 'Mindset',
        count: 88,
        backgroundAssetName: 'https://images.unsplash.com/photo-1507499739999-097706ad8914?auto=format&fit=crop&w=600&q=80',
      },
    ];

    const featured = [
      {
        id: 'feat-1',
        tag: 'Daily Boost',
        tagSystemIcon: 'sparkles',
        tagColorHex: '#F59E0B',
        quote: 'Small steps every day lead to big changes over time.',
        highlight: 'Keep showing up.',
        backgroundAssetName: 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
        likeCount: 4800,
        isLiked: false,
      },
      {
        id: 'feat-2',
        tag: 'Mindset',
        tagSystemIcon: 'sparkles',
        tagColorHex: '#8B5CF6',
        quote: 'Your future is created by what you do today, not tomorrow.',
        highlight: null,
        backgroundAssetName: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?auto=format&fit=crop&w=800&q=80',
        likeCount: 3200,
        isLiked: true,
      },
      {
        id: 'feat-3',
        tag: 'Discipline',
        tagSystemIcon: 'mountain.2.fill',
        tagColorHex: '#10B981',
        quote: 'Discipline is choosing what you want most over what you want now.',
        highlight: null,
        backgroundAssetName: 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?auto=format&fit=crop&w=800&q=80',
        likeCount: 2700,
        isLiked: false,
      },
    ];

    const trending = [
      { id: 'trend-1', title: 'Building Habits', viewsLabel: '24.1k', iconAssetName: 'onboarding_icon_discipline', accentHex: '#8B5CF6' },
      { id: 'trend-2', title: 'Morning Routine', viewsLabel: '18.7k', iconAssetName: 'onboarding_icon_sun', accentHex: '#F59E0B' },
      { id: 'trend-3', title: 'Overcoming Fear', viewsLabel: '16.3k', iconAssetName: 'onboarding_icon_growth', accentHex: '#A5A1C8' },
      { id: 'trend-4', title: 'Consistency', viewsLabel: '21.4k', iconAssetName: 'onboarding_icon_refresh', accentHex: '#10B981' },
    ];

    const moods = [
      { id: 'stressed', title: 'Stressed', iconAssetName: 'discover_mood_stressed', accentColor: '#8B5CF6' },
      { id: 'overwhelmed', title: 'Overwhelmed', iconAssetName: 'discover_mood_overwhelmed', accentColor: '#F59E0B' },
      { id: 'discouraged', title: 'Discouraged', iconAssetName: 'discover_mood_discouraged', accentColor: '#EF4444' },
      { id: 'unmotivated', title: 'Unmotivated', iconAssetName: 'discover_mood_unmotivated', accentColor: '#3B82F6' },
    ];

    return {
      dailyThought,
      dailyAffirmation,
      categories,
      featured,
      trending,
      moods,
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
