//
//  admin.types.ts
//  RiseAdmin
//
//  Type definitions matching RiseServer API contracts
//

export interface PlatformSummary {
  totalUsers: number;
  proUsers: number;
  freeUsers: number;
  conversionRate: string;
  totalQuotes: number;
  totalAffirmations: number;
  totalPacks: number;
  totalJournals: number;
  totalIntentions: number;
  activeDevices: number;
  serverTime: string;
}

export interface PackCurriculumItem {
  day: number;
  title: string;
  type: 'BOOST' | 'AUDIO' | 'REFLECTION' | 'BREATHE';
  content: string;
  durationMinutes: number;
  assetName: string;
  audioUrl?: string;
}

export interface AdminPack {
  id: string;
  slug: string;
  title: string;
  subtitle: string;
  description: string;
  heroArtwork: string;
  theme: string;
  category: string;
  durationDays: number;
  accessLevel: 'FREE' | 'PRO' | 'STOREKIT_PURCHASE';
  storeKitProductId: string | null;
  priceTier: string;
  version: number;
  items: PackCurriculumItem[];
  isPublished: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface AdminQuote {
  id: string;
  quote: string;
  author: string;
  category: string;
  tags: string[];
  assetName: string;
  dayOfYear?: number | null;
  isFeatured: boolean;
  createdAt: string;
  updatedAt: string;
}

export interface AdminAffirmation {
  id: string;
  text: string;
  category: string;
  tags: string[];
  accessLevel: 'FREE' | 'PRO';
  dayOfYear?: number | null;
  assetName: string;
  createdAt: string;
}

export interface AdminUser {
  id: string;
  email: string | null;
  name: string;
  avatarUrl: string | null;
  role: 'USER' | 'CURATOR' | 'ADMIN';
  subscriptionTier: 'FREE' | 'PRO_MONTHLY' | 'PRO_ANNUAL' | 'LIFETIME';
  subscriptionExpiresAt: string | null;
  focusAreas: string[];
  onboardingComplete: boolean;
  timeZone: string;
  createdAt: string;
  streak: number;
  mindfulMinutes: number;
  journalCount: number;
  intentionCount: number;
  packCount: number;
}

export interface ApiResponse<T> {
  success: boolean;
  data: T;
  meta?: {
    total?: number;
    page?: number;
    limit?: number;
    totalPages?: number;
    timestamp: string;
  };
}
