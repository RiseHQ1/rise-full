//
//  constants.ts
//  RiseAdmin
//
//  Shared constants matching Rise app taxonomy and specifications
//

export const RISE_CATEGORIES = [
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
  'Clarity',
  'Motivation',
  'Positivity',
  'Wisdom',
] as const;

export const PACK_THEMES = [
  { id: 'sunrise_gold', label: 'Sunrise Gold (Amber)', bgClass: 'from-amber-950/40 to-slate-900' },
  { id: 'warm_amber', label: 'Warm Amber (Courage)', bgClass: 'from-orange-950/40 to-slate-900' },
  { id: 'indigo_depth', label: 'Indigo Depth (Focus)', bgClass: 'from-indigo-950/40 to-slate-900' },
  { id: 'midnight_navy', label: 'Midnight Navy (Sleep)', bgClass: 'from-slate-950/60 to-slate-900' },
  { id: 'rose_quartz', label: 'Rose Quartz (Self-Love)', bgClass: 'from-rose-950/40 to-slate-900' },
  { id: 'emerald_growth', label: 'Emerald Growth (Habits)', bgClass: 'from-emerald-950/40 to-slate-900' },
  { id: 'sky_clarity', label: 'Sky Clarity (Fresh Start)', bgClass: 'from-sky-950/40 to-slate-900' },
  { id: 'royal_violet', label: 'Royal Violet (Mastery)', bgClass: 'from-purple-950/40 to-slate-900' },
] as const;

export const SESSION_TYPES = [
  { id: 'BOOST', label: 'Daily Boost (Text Reflection)', icon: 'Sparkles' },
  { id: 'AUDIO', label: 'Guided Audio Meditation', icon: 'Headphones' },
  { id: 'REFLECTION', label: 'Journal Prompt', icon: 'BookOpen' },
  { id: 'BREATHE', label: 'Breathing Reset Exercise', icon: 'Wind' },
] as const;

export const ACCESS_LEVELS = [
  { id: 'FREE', label: 'Free (All Users)' },
  { id: 'PRO', label: 'Rise Pro Subscription' },
  { id: 'STOREKIT_PURCHASE', label: 'In-App Non-Consumable Purchase' },
] as const;

export const SUBSCRIPTION_TIERS = [
  { id: 'FREE', label: 'Free Tier' },
  { id: 'PRO_MONTHLY', label: 'Pro Monthly ($4.99/mo)' },
  { id: 'PRO_ANNUAL', label: 'Pro Annual ($29.99/yr)' },
  { id: 'LIFETIME', label: 'Pro Lifetime ($99.99)' },
] as const;
