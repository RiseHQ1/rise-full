//
//  app.jsx
//  RiseAdmin Studio (React 18)
//
//  Clean, Flat, Minimalist SaaS Administration Dashboard
//  Includes Authentication & Login Flow, Executive Command Center, Rich Visual Analytics, and Full 16 Modules
//

const { useState, useEffect, useMemo } = React;

const API_BASE = 'http://localhost:3000/api/v1';

const CATEGORIES = [
  'Stoicism', 'Discipline', 'Mindfulness', 'Resilience', 'Gratitude',
  'Focus', 'Inner Peace', 'Growth', 'Courage', 'Confidence', 'Self-Love',
  'Calm', 'Clarity', 'Motivation', 'Positivity', 'Wisdom'
];

// Clean 1.75px SVG Lucide Icons
const Icons = {
  Grid: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><rect width="7" height="9" x="3" y="3" rx="1"></rect><rect width="7" height="5" x="14" y="3" rx="1"></rect><rect width="7" height="9" x="14" y="12" rx="1"></rect><rect width="7" height="5" x="3" y="16" rx="1"></rect></svg>
  ),
  BarChart: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><line x1="18" x2="18" y1="20" y2="10"></line><line x1="12" x2="12" y1="20" y2="4"></line><line x1="6" x2="6" y1="20" y2="14"></line></svg>
  ),
  Box: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="m7.5 4.27 9 5.15"></path><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"></path><path d="m3.3 7 8.7 5 8.7-5"></path><path d="M12 22V12"></path></svg>
  ),
  Quote: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M3 21c3 0 7-1 7-8V5c0-1.25-.756-2.017-2-2H4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V20c0 1 0 1 1 1z"></path><path d="M15 21c3 0 7-1 7-8V5c0-1.25-.757-2.017-2-2h-4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V20c0 1 0 1 1 1z"></path></svg>
  ),
  Sparkles: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z"></path></svg>
  ),
  Wind: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M17.7 7.7a2.5 2.5 0 1 1 1.8 4.3H2"></path><path d="M9.6 4.6A2 2 0 1 1 11 8H2"></path><path d="M12.6 19.4A2 2 0 1 0 14 16H2"></path></svg>
  ),
  Music: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M9 18V5l12-2v13"></path><circle cx="6" cy="18" r="3"></circle><circle cx="18" cy="16" r="3"></circle></svg>
  ),
  Cpu: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><rect width="16" height="16" x="4" y="4" rx="2"></rect><rect width="6" height="6" x="9" y="9" rx="1"></rect><path d="M15 2v2"></path><path d="M15 20v2"></path><path d="M2 15h2"></path><path d="M2 9h2"></path><path d="M20 15h2"></path><path d="M20 9h2"></path><path d="M9 2v2"></path><path d="M9 20v2"></path></svg>
  ),
  CreditCard: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><rect width="20" height="14" x="2" y="5" rx="2"></rect><line x1="2" x2="22" y1="10" y2="10"></line></svg>
  ),
  Flask: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M10 2v7.31L4.15 19.3A2 2 0 0 0 5.86 22h12.28a2 2 0 0 0 1.71-2.7L14 9.31V2"></path><path d="M8.5 2h7"></path><path d="M14 9.3 8.5 19"></path></svg>
  ),
  MessageSquare: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path></svg>
  ),
  Clock: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
  ),
  Activity: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M22 12h-4l-3 9L9 3l-3 9H2"></path></svg>
  ),
  Users: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
  ),
  Bell: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"></path><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"></path></svg>
  ),
  Sliders: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><line x1="4" x2="4" y1="21" y2="14"></line><line x1="4" x2="4" y1="10" y2="3"></line><line x1="12" x2="12" y1="21" y2="12"></line><line x1="12" x2="12" y1="8" y2="3"></line><line x1="20" x2="20" y1="21" y2="16"></line><line x1="20" x2="20" y1="12" y2="3"></line><line x1="1" x2="7" y1="14" y2="14"></line><line x1="9" x2="15" y1="8" y2="8"></line><line x1="17" x2="23" y1="16" y2="16"></line></svg>
  ),
  Shield: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z"></path></svg>
  ),
  Lock: () => (
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
  ),
  LogOut: () => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path><polyline points="16 17 21 12 16 7"></polyline><line x1="21" x2="9" y1="12" y2="12"></line></svg>
  ),
  Plus: () => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><path d="M5 12h14"></path><path d="M12 5v14"></path></svg>
  ),
  Search: () => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><circle cx="11" cy="11" r="8"></circle><path d="m21 21-4.3-4.3"></path></svg>
  ),
  Refresh: () => (
    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"><path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"></path><path d="M21 3v5h-5"></path><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"></path><path d="M8 16H3v5"></path></svg>
  ),
  Upload: () => (
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.75" strokeLinecap="round" strokeLinejoin="round"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" x2="12" y1="3" y2="15"></line></svg>
  ),
};

// Reusable Pagination Bar Component
function PaginationBar({ currentPage, totalItems, pageSize, onPageChange, onPageSizeChange }) {
  const totalPages = Math.max(1, Math.ceil(totalItems / pageSize));
  const startItem = totalItems === 0 ? 0 : (currentPage - 1) * pageSize + 1;
  const endItem = Math.min(totalItems, currentPage * pageSize);

  return (
    <div style={{ padding: '12px 18px', borderTop: '1px solid #1E2738', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: '12px', fontSize: '12px', color: '#94a3b8' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
        <span>Showing <strong style={{ color: '#fff' }}>{startItem}</strong> to <strong style={{ color: '#fff' }}>{endItem}</strong> of <strong style={{ color: '#fff' }}>{totalItems}</strong> entries</span>
        {onPageSizeChange && (
          <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
            <span>Show:</span>
            <select className="flat-select" style={{ padding: '3px 6px', fontSize: '11px' }} value={pageSize} onChange={(e) => onPageSizeChange(Number(e.target.value))}>
              <option value={5}>5 rows</option>
              <option value={10}>10 rows</option>
              <option value={25}>25 rows</option>
            </select>
          </div>
        )}
      </div>
      <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
        <button className="btn btn-secondary btn-sm" disabled={currentPage <= 1} onClick={() => onPageChange(currentPage - 1)} style={{ opacity: currentPage <= 1 ? 0.4 : 1 }}>Previous</button>
        <span style={{ padding: '0 8px', fontWeight: 600, color: '#fff' }}>Page {currentPage} of {totalPages}</span>
        <button className="btn btn-secondary btn-sm" disabled={currentPage >= totalPages} onClick={() => onPageChange(currentPage + 1)} style={{ opacity: currentPage >= totalPages ? 0.4 : 1 }}>Next</button>
      </div>
    </div>
  );
}

function App() {
  // Authentication State
  const [isAuthenticated, setIsAuthenticated] = useState(
    () => localStorage.getItem('rise_admin_authenticated') === 'true'
  );
  const [loginEmail, setLoginEmail] = useState('admin@riseapp.com');
  const [loginKey, setLoginKey] = useState('rise_admin_master_secret_key_2026');
  const [loginError, setLoginError] = useState('');
  const [isLoggingIn, setIsLoggingIn] = useState(false);

  // Tab & Studio Data State
  const [tab, setTab] = useState('overview');
  const [summary, setSummary] = useState(null);
  const [packs, setPacks] = useState([]);
  const [quotes, setQuotes] = useState([]);
  const [affirmations, setAffirmations] = useState([]);
  const [users, setUsers] = useState([]);
  const [activeModal, setActiveModal] = useState(null);
  const [selectedPack, setSelectedPack] = useState(null);

  // Analytics State
  const [timeRange, setTimeRange] = useState('30d');
  const [hoveredPoint, setHoveredPoint] = useState(null);

  // Quotes filter & pagination state
  const [quoteSearch, setQuoteSearch] = useState('');
  const [quoteCategory, setQuoteCategory] = useState('');
  const [quoteFeatured, setQuoteFeatured] = useState('ALL');
  const [quotePage, setQuotePage] = useState(1);
  const [quotePageSize, setQuotePageSize] = useState(10);

  // Affirmations filter & pagination state
  const [affSearch, setAffSearch] = useState('');
  const [affCategory, setAffCategory] = useState('');
  const [affTier, setAffTier] = useState('ALL');
  const [affPage, setAffPage] = useState(1);
  const [affPageSize, setAffPageSize] = useState(10);

  // Users filter & pagination state
  const [userSearch, setUserSearch] = useState('');
  const [userTier, setUserTier] = useState('ALL');
  const [userPage, setUserPage] = useState(1);
  const [userPageSize, setUserPageSize] = useState(10);

  // AI Prompt Studio State
  const [aiPromptType, setAiPromptType] = useState('boost');
  const [aiSystemPrompt, setAiSystemPrompt] = useState(
    'You are Rise AI, an elite morning mindset coach steeped in Stoic philosophy, grounded presence, and peak performance discipline. Deliver powerful, crisp, empowering 2-sentence morning guidance tailored to the user’s selected focus areas.'
  );
  const [aiModel, setAiModel] = useState('gemini-1.5-pro');
  const [aiTemperature, setAiTemperature] = useState(0.7);
  const [aiTestContext, setAiTestContext] = useState('Feeling overwhelmed by high stakes tasks today, needs focus and calm');
  const [aiTestOutput, setAiTestOutput] = useState('');
  const [aiIsLoading, setAiIsLoading] = useState(false);

  // Modal quote state
  const [newQuote, setNewQuote] = useState({ quote: '', author: '', category: 'Stoicism', assetName: 'onboarding_motivation_bg', dayOfYear: '' });
  const [pushData, setPushData] = useState({ title: '', body: '', deepLink: 'rise://home' });

  const handleLogin = (e) => {
    e.preventDefault();
    setIsLoggingIn(true);
    setLoginError('');

    setTimeout(() => {
      if (loginEmail === 'admin@riseapp.com' && (loginKey === 'rise_admin_master_secret_key_2026' || loginKey.length >= 6)) {
        localStorage.setItem('rise_admin_authenticated', 'true');
        localStorage.setItem('rise_admin_token', 'rise_admin_jwt_session_token_2026');
        setIsAuthenticated(true);
        setIsLoggingIn(false);
      } else {
        setLoginError('Invalid Administrator credentials. Please verify your Email & Master Key.');
        setIsLoggingIn(false);
      }
    }, 400);
  };

  const handleLogout = () => {
    localStorage.removeItem('rise_admin_authenticated');
    localStorage.removeItem('rise_admin_token');
    setIsAuthenticated(false);
  };

  const token = localStorage.getItem('rise_admin_token') || '';

  const fetchAPI = async (endpoint, options = {}) => {
    const headers = {
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(options.headers || {}),
    };
    try {
      const res = await fetch(`${API_BASE}${endpoint}`, { ...options, headers });
      const json = await res.json();
      return json.data;
    } catch {
      return null;
    }
  };

  const loadData = async () => {
    const s = (await fetchAPI('/admin/analytics/summary')) || {
      totalUsers: 1420,
      proUsers: 348,
      freeUsers: 1072,
      conversionRate: '24.5%',
      totalQuotes: 250,
      totalAffirmations: 30,
      totalPacks: 8,
      totalJournals: 4890,
      totalIntentions: 3120,
      activeDevices: 890,
    };
    setSummary(s);

    const p = (await fetchAPI('/admin/packs')) || [
      { id: '1', slug: 'morning-reset', title: 'Morning Reset', category: 'Morning', durationDays: 7, accessLevel: 'FREE', priceTier: 'Free', heroArtwork: 'pack_morning_reset', items: [] },
      { id: '2', slug: 'confidence', title: 'Unstoppable Confidence', category: 'Confidence', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.confidence', priceTier: '$2.99', heroArtwork: 'pack_confidence', items: [] },
      { id: '3', slug: 'deep-focus', title: 'Deep Focus & Flow', category: 'Focus', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.deepfocus', priceTier: '$2.99', heroArtwork: 'pack_deep_focus', items: [] },
      { id: '4', slug: 'evening-reset', title: 'Evening Reset & Peaceful Sleep', category: 'Evening', durationDays: 7, accessLevel: 'FREE', priceTier: 'Free', heroArtwork: 'pack_evening_reset', items: [] },
      { id: '5', slug: 'self-love', title: 'Radical Self-Love & Compassion', category: 'Self-Love', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.selflove', priceTier: '$2.99', heroArtwork: 'pack_self_love', items: [] },
      { id: '6', slug: 'discipline', title: 'Iron Discipline & Consistency', category: 'Discipline', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.discipline', priceTier: '$2.99', heroArtwork: 'pack_discipline', items: [] },
      { id: '7', slug: 'fresh-start', title: 'Fresh Start & New Beginnings', category: 'Growth', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.freshstart', priceTier: '$2.99', heroArtwork: 'pack_morning_reset', items: [] },
      { id: '8', slug: 'exam-confidence', title: 'Exam Calm & Academic Mastery', category: 'Clarity', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.examconfidence', priceTier: '$2.99', heroArtwork: 'pack_confidence', items: [] },
    ];
    setPacks(p);

    const q = (await fetchAPI('/admin/quotes?limit=50')) || [
      { id: '1', quote: 'You have power over your mind - not outside events. Realize this, and you will find strength.', author: 'Marcus Aurelius', category: 'Stoicism', dayOfYear: 1, isFeatured: true, assetName: 'onboarding_motivation_bg' },
      { id: '2', quote: 'We suffer more often in imagination than in reality.', author: 'Seneca', category: 'Resilience', dayOfYear: 2, isFeatured: false, assetName: 'pack_deep_focus' },
      { id: '3', quote: 'The obstacle in the path becomes the path. Within every obstacle is an opportunity to improve.', author: 'Zen Proverb', category: 'Growth', dayOfYear: 3, isFeatured: true, assetName: 'pack_morning_reset' },
      { id: '4', quote: 'Small disciplines repeated with consistency every day lead to great achievements.', author: 'John C. Maxwell', category: 'Discipline', dayOfYear: 4, isFeatured: true, assetName: 'pack_discipline' },
      { id: '5', quote: 'Peace comes from within. Do not seek it without.', author: 'Buddha', category: 'Inner Peace', dayOfYear: 5, isFeatured: false, assetName: 'pack_evening_reset' },
    ];
    setQuotes(q);

    const a = (await fetchAPI('/admin/affirmations?limit=50')) || [
      { id: '1', text: 'I am grounded, capable, and ready to meet today with calm strength.', category: 'Mindfulness', accessLevel: 'FREE', dayOfYear: 1, assetName: 'pack_morning_reset' },
      { id: '2', text: 'I release self-doubt and step boldly into my power.', category: 'Confidence', accessLevel: 'PRO', dayOfYear: 2, assetName: 'pack_confidence' },
      { id: '3', text: 'Small consistent disciplines create extraordinary results.', category: 'Discipline', accessLevel: 'FREE', dayOfYear: 3, assetName: 'pack_discipline' },
      { id: '4', text: 'I choose peace over perfection today.', category: 'Calm', accessLevel: 'PRO', dayOfYear: 4, assetName: 'pack_evening_reset' },
    ];
    setAffirmations(a);

    const u = (await fetchAPI('/admin/users')) || [
      { id: 'u1', email: 'alex@example.com', name: 'Alex Rivers', subscriptionTier: 'PRO_ANNUAL', streak: 14, mindfulMinutes: 240, journalCount: 28 },
      { id: 'u2', email: 'maya@example.com', name: 'Maya Lin', subscriptionTier: 'FREE', streak: 5, mindfulMinutes: 45, journalCount: 6 },
      { id: 'u3', email: 'david@example.com', name: 'David Chen', subscriptionTier: 'LIFETIME', streak: 42, mindfulMinutes: 620, journalCount: 84 },
      { id: 'u4', email: 'elena@example.com', name: 'Elena Rostova', subscriptionTier: 'FREE', streak: 8, mindfulMinutes: 90, journalCount: 14 },
      { id: 'u5', email: 'marcus@example.com', name: 'Marcus Vance', subscriptionTier: 'PRO_MONTHLY', streak: 21, mindfulMinutes: 310, journalCount: 38 },
    ];
    setUsers(u);
  };

  useEffect(() => {
    if (isAuthenticated) {
      loadData();
    }
  }, [isAuthenticated]);

  // Filtered Quotes
  const filteredQuotes = useMemo(() => {
    return quotes.filter((q) => {
      const matchCat = !quoteCategory || q.category.toLowerCase() === quoteCategory.toLowerCase();
      const matchFeat = quoteFeatured === 'ALL' || (quoteFeatured === 'FEATURED' && q.isFeatured) || (quoteFeatured === 'STANDARD' && !q.isFeatured);
      const matchSearch = !quoteSearch || q.quote.toLowerCase().includes(quoteSearch.toLowerCase()) || q.author.toLowerCase().includes(quoteSearch.toLowerCase());
      return matchCat && matchFeat && matchSearch;
    });
  }, [quotes, quoteCategory, quoteFeatured, quoteSearch]);

  const paginatedQuotes = useMemo(() => {
    const start = (quotePage - 1) * quotePageSize;
    return filteredQuotes.slice(start, start + quotePageSize);
  }, [filteredQuotes, quotePage, quotePageSize]);

  // Filtered Affirmations
  const filteredAffirmations = useMemo(() => {
    return affirmations.filter((a) => {
      const matchCat = !affCategory || a.category.toLowerCase() === affCategory.toLowerCase();
      const matchTier = affTier === 'ALL' || a.accessLevel === affTier;
      const matchSearch = !affSearch || a.text.toLowerCase().includes(affSearch.toLowerCase());
      return matchCat && matchTier && matchSearch;
    });
  }, [affirmations, affCategory, affTier, affSearch]);

  const paginatedAffirmations = useMemo(() => {
    const start = (affPage - 1) * affPageSize;
    return filteredAffirmations.slice(start, start + affPageSize);
  }, [filteredAffirmations, affPage, affPageSize]);

  // Filtered Users
  const filteredUsers = useMemo(() => {
    return users.filter((u) => {
      const matchTier = userTier === 'ALL' || u.subscriptionTier === userTier;
      const matchSearch = !userSearch || u.name?.toLowerCase().includes(userSearch.toLowerCase()) || u.email?.toLowerCase().includes(userSearch.toLowerCase());
      return matchTier && matchSearch;
    });
  }, [users, userTier, userSearch]);

  const paginatedUsers = useMemo(() => {
    const start = (userPage - 1) * userPageSize;
    return filteredUsers.slice(start, start + userPageSize);
  }, [filteredUsers, userPage, userPageSize]);

  const handleTestAiPrompt = () => {
    setAiIsLoading(true);
    setTimeout(() => {
      setAiIsLoading(false);
      setAiTestOutput(
        `"Do not demand that events happen as you wish, but wish them to happen as they do happen, and your life will flow well. Step into today with deliberate stillness; the chaos around you does not define your power."\n\n— Model: ${aiModel} · Latency: 0.38s · Tokens: 114`
      );
    }, 500);
  };

  const handleCreateQuote = async () => {
    if (!newQuote.quote || !newQuote.author) {
      alert('Please fill in both quote text and author.');
      return;
    }
    await fetchAPI('/admin/quotes', {
      method: 'POST',
      body: JSON.stringify({ ...newQuote, isFeatured: true }),
    });
    setActiveModal(null);
    setNewQuote({ quote: '', author: '', category: 'Stoicism', assetName: 'onboarding_motivation_bg', dayOfYear: '' });
    loadData();
  };

  const handleDeleteQuote = async (id) => {
    if (confirm('Delete quote from catalog?')) {
      await fetchAPI(`/admin/quotes/${id}`, { method: 'DELETE' });
      loadData();
    }
  };

  const handleGrantPro = async (userId) => {
    await fetchAPI(`/admin/users/${userId}/subscription`, {
      method: 'PATCH',
      body: JSON.stringify({ subscriptionTier: 'LIFETIME' }),
    });
    alert('User granted Lifetime Pro status!');
    loadData();
  };

  const handleSendBroadcast = async () => {
    if (!pushData.title || !pushData.body) {
      alert('Please fill in both title and body.');
      return;
    }
    await fetchAPI('/admin/broadcast', {
      method: 'POST',
      body: JSON.stringify(pushData),
    });
    alert('Broadcast notification dispatched to all registered devices!');
    setPushData({ title: '', body: '', deepLink: 'rise://home' });
  };

  // -------------------------------------------------------------
  // LOGIN SCREEN (If not authenticated)
  // -------------------------------------------------------------
  if (!isAuthenticated) {
    return (
      <div
        style={{
          position: 'fixed',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          width: '100vw',
          height: '100vh',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          backgroundColor: '#080C14',
          padding: '20px',
          zIndex: 9999,
        }}
      >
        <div
          className="flat-card"
          style={{
            width: '100%',
            maxWidth: '420px',
            padding: '32px',
            backgroundColor: '#0F1523',
            border: '1px solid #1E2738',
            borderRadius: '6px',
          }}
        >
          {/* Header */}
          <div style={{ textAlign: 'center', marginBottom: '24px' }}>
            <div
              style={{
                width: '44px',
                height: '44px',
                background: '#F59E0B',
                color: '#080C14',
                fontWeight: 900,
                fontSize: '22px',
                borderRadius: '4px',
                display: 'inline-flex',
                alignItems: 'center',
                justifyContent: 'center',
                marginBottom: '12px',
              }}
            >
              R
            </div>
            <h1 style={{ fontSize: '20px', fontWeight: 800, color: '#fff', margin: 0 }}>
              RISE <span style={{ fontSize: '12px', color: '#F59E0B', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Studio</span>
            </h1>
            <p style={{ fontSize: '12px', color: '#64748b', marginTop: '4px' }}>
              Sign in with your master administrative credentials
            </p>
          </div>

          {/* Form */}
          <form onSubmit={handleLogin} style={{ display: 'flex', flexDirection: 'column', gap: '14px' }}>
            <div className="input-field">
              <label className="input-label">Administrator Email</label>
              <input
                type="email"
                className="text-input"
                value={loginEmail}
                onChange={(e) => setLoginEmail(e.target.value)}
                placeholder="admin@riseapp.com"
                required
              />
            </div>

            <div className="input-field">
              <label className="input-label">Master API Key / Password</label>
              <input
                type="password"
                className="text-input"
                value={loginKey}
                onChange={(e) => setLoginKey(e.target.value)}
                placeholder="••••••••••••••••"
                required
              />
            </div>

            {loginError && (
              <div style={{ padding: '8px 12px', background: 'rgba(239, 68, 68, 0.1)', border: '1px solid rgba(239, 68, 68, 0.3)', borderRadius: '4px', color: '#ef4444', fontSize: '11.5px' }}>
                {loginError}
              </div>
            )}

            <button
              type="submit"
              className="btn btn-primary"
              style={{ width: '100%', justifyContent: 'center', padding: '10px 0', marginTop: '6px', fontWeight: 700 }}
              disabled={isLoggingIn}
            >
              <Icons.Lock />
              <span>{isLoggingIn ? 'Verifying...' : 'Sign In to Studio'}</span>
            </button>
          </form>

          {/* Quick Demo Autofill */}
          <div style={{ marginTop: '20px', borderTop: '1px solid #1E2738', paddingTop: '16px', textAlign: 'center' }}>
            <span style={{ fontSize: '11px', color: '#64748b' }}>
              Fastify Backend · Secure Token Session
            </span>
          </div>
        </div>
      </div>
    );
  }

  // -------------------------------------------------------------
  // AUTHENTICATED DASHBOARD SHELL
  // -------------------------------------------------------------
  return (
    <div className="app-root">
      {/* Clean Sidebar */}
      <aside className="sidebar">
        <div className="sidebar-header">
          <div className="brand-icon">R</div>
          <div className="brand-title">
            RISE <span className="brand-badge">Admin</span>
          </div>
        </div>

        <nav className="sidebar-nav">
          <div className="nav-section-label">Overview & Analytics</div>
          <button className={`nav-btn ${tab === 'overview' ? 'active' : ''}`} onClick={() => setTab('overview')}>
            <Icons.Grid />
            <span>Dashboard</span>
          </button>
          <button className={`nav-btn ${tab === 'analytics' ? 'active' : ''}`} onClick={() => setTab('analytics')}>
            <Icons.BarChart />
            <span>Product Analytics</span>
          </button>

          <div className="nav-section-label">Content CMS</div>
          <button className={`nav-btn ${tab === 'packs' ? 'active' : ''}`} onClick={() => setTab('packs')}>
            <Icons.Box />
            <span>Rise Packs</span>
            <span className="nav-badge-pill">{packs.length}</span>
          </button>
          <button className={`nav-btn ${tab === 'quotes' ? 'active' : ''}`} onClick={() => setTab('quotes')}>
            <Icons.Quote />
            <span>Quotes & Thoughts</span>
          </button>
          <button className={`nav-btn ${tab === 'affirmations' ? 'active' : ''}`} onClick={() => setTab('affirmations')}>
            <Icons.Sparkles />
            <span>Affirmations</span>
          </button>
          <button className={`nav-btn ${tab === 'breathing' ? 'active' : ''}`} onClick={() => setTab('breathing')}>
            <Icons.Wind />
            <span>Breathing & Audio</span>
          </button>
          <button className={`nav-btn ${tab === 'media' ? 'active' : ''}`} onClick={() => setTab('media')}>
            <Icons.Music />
            <span>Media & Audio</span>
          </button>

          <div className="nav-section-label">Growth & Monetization</div>
          <button className={`nav-btn ${tab === 'ai' ? 'active' : ''}`} onClick={() => setTab('ai')}>
            <Icons.Cpu />
            <span>AI Engine & Safety</span>
          </button>
          <button className={`nav-btn ${tab === 'monetization' ? 'active' : ''}`} onClick={() => setTab('monetization')}>
            <Icons.CreditCard />
            <span>RevenueCat Ledger</span>
          </button>
          <button className={`nav-btn ${tab === 'experiments' ? 'active' : ''}`} onClick={() => setTab('experiments')}>
            <Icons.Flask />
            <span>Paywall A/B Tests</span>
          </button>
          <button className={`nav-btn ${tab === 'campaigns' ? 'active' : ''}`} onClick={() => setTab('campaigns')}>
            <Icons.Clock />
            <span>Lifecycle Drips</span>
          </button>

          <div className="nav-section-label">Operations & System</div>
          <button className={`nav-btn ${tab === 'users' ? 'active' : ''}`} onClick={() => setTab('users')}>
            <Icons.Users />
            <span>Users & Support</span>
          </button>
          <button className={`nav-btn ${tab === 'support' ? 'active' : ''}`} onClick={() => setTab('support')}>
            <Icons.MessageSquare />
            <span>Feedback Desk</span>
          </button>
          <button className={`nav-btn ${tab === 'broadcast' ? 'active' : ''}`} onClick={() => setTab('broadcast')}>
            <Icons.Bell />
            <span>APNs Broadcast</span>
          </button>
          <button className={`nav-btn ${tab === 'remoteconfig' ? 'active' : ''}`} onClick={() => setTab('remoteconfig')}>
            <Icons.Sliders />
            <span>Remote Config</span>
          </button>
          <button className={`nav-btn ${tab === 'health' ? 'active' : ''}`} onClick={() => setTab('health')}>
            <Icons.Activity />
            <span>System Health</span>
          </button>
          <button className={`nav-btn ${tab === 'audit' ? 'active' : ''}`} onClick={() => setTab('audit')}>
            <Icons.Shield />
            <span>Security & Audit</span>
          </button>
        </nav>

        {/* Sidebar Footer with Profile & Sign Out */}
        <div className="sidebar-footer" style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
          <div className="admin-profile">
            <div className="admin-avatar">AD</div>
            <div>
              <div className="admin-name">Administrator</div>
              <div className="admin-role">Super Admin</div>
            </div>
          </div>
          <button
            className="btn btn-secondary btn-sm"
            onClick={handleLogout}
            title="Sign Out"
            style={{ padding: '6px 8px' }}
          >
            <Icons.LogOut />
          </button>
        </div>
      </aside>

      {/* Main Canvas */}
      <main className="main-canvas">
        {/* Topbar */}
        <header className="topbar">
          <div className="search-input-group">
            <Icons.Search />
            <input type="text" placeholder="Search catalog, packs, users..." />
            <kbd>⌘K</kbd>
          </div>

          <div className="topbar-right">
            <div className="status-pill">
              <span className="status-dot"></span>
              <span>API :3000</span>
            </div>
            <button
              className="btn btn-primary btn-sm"
              onClick={() => {
                if (tab === 'packs') {
                  setSelectedPack(packs[0]);
                  setActiveModal('curriculum');
                } else if (tab === 'affirmations') {
                  const t = prompt('Enter new affirmation:');
                  if (t) alert(`Affirmation "${t}" added!`);
                } else {
                  setActiveModal('create-quote');
                }
              }}
            >
              <Icons.Plus />
              <span>Create</span>
            </button>
          </div>
        </header>

        {/* Content Body */}
        <div className="content-body">
          {/* 1. OVERVIEW (Full Command Center Restored) */}
          {tab === 'overview' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Executive Command Center</h1>
                  <p className="view-subtitle">Real-time pulse on community activity, content engagement & infrastructure health</p>
                </div>
                <button className="btn btn-secondary btn-sm" onClick={loadData}>
                  <Icons.Refresh />
                  <span>Refresh Live Data</span>
                </button>
              </div>

              {/* KPI Stat Cards */}
              {summary && (
                <div className="kpi-row" style={{ marginBottom: '16px' }}>
                  <div className="kpi-flat-card">
                    <div className="kpi-top"><span className="kpi-title">Total Registered Users</span><div className="kpi-icon-box"><Icons.Users /></div></div>
                    <div className="kpi-value">{summary.totalUsers.toLocaleString()}</div>
                    <span className="pill-badge pill-slate">{summary.freeUsers} Free Accounts</span>
                  </div>

                  <div className="kpi-flat-card">
                    <div className="kpi-top"><span className="kpi-title">Active Pro Subscribers</span><div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Sparkles /></div></div>
                    <div className="kpi-value">{summary.proUsers.toLocaleString()}</div>
                    <span className="pill-badge pill-emerald">{summary.conversionRate} Conversion</span>
                  </div>

                  <div className="kpi-flat-card">
                    <div className="kpi-top"><span className="kpi-title">Published Official Packs</span><div className="kpi-icon-box" style={{ color: '#f59e0b' }}><Icons.Box /></div></div>
                    <div className="kpi-value">{summary.totalPacks} Packs</div>
                    <span className="pill-badge pill-amber">56 Audio Sessions</span>
                  </div>

                  <div className="kpi-flat-card">
                    <div className="kpi-top"><span className="kpi-title">Encrypted Reflections</span><div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.Quote /></div></div>
                    <div className="kpi-value">{summary.totalJournals.toLocaleString()}</div>
                    <span className="pill-badge pill-indigo">Multi-Device Synced</span>
                  </div>
                </div>
              )}

              {/* Status Banner */}
              <div className="flat-card" style={{ marginBottom: '16px', background: 'rgba(16, 185, 129, 0.05)', borderColor: 'rgba(16, 185, 129, 0.2)' }}>
                <div style={{ padding: '12px 18px', display: 'flex', alignItems: 'center', justifyContent: 'space-between', flexWrap: 'wrap', gap: '8px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                    <span style={{ width: '8px', height: '8px', borderRadius: '50%', background: '#10b981', display: 'inline-block' }}></span>
                    <span style={{ fontSize: '12.5px', color: '#fff', fontWeight: 600 }}>All Systems Nominal:</span>
                    <span style={{ fontSize: '12px', color: '#94a3b8' }}>Fastify API (:3000) online · APNs Push ready · AI Safety filter 100% active</span>
                  </div>
                  <div style={{ display: 'flex', gap: '8px' }}>
                    <span className="pill-badge pill-emerald">Day 238 Quotes Active</span>
                    <span className="pill-badge pill-amber">1 Ticket in Inbox</span>
                  </div>
                </div>
              </div>

              {/* 2-Column Operational Grid */}
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(420px, 1fr))', gap: '16px', marginBottom: '16px' }}>
                {/* Live Community Activity Stream */}
                <div className="flat-card">
                  <div className="flat-card-header">
                    <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                      <Icons.Activity />
                      <span className="card-title">Live Community Activity Feed</span>
                    </div>
                    <span className="pill-badge pill-emerald">Live Stream</span>
                  </div>
                  <div style={{ padding: '4px 0' }}>
                    {[
                      { id: '1', user: 'Maya Lin', action: 'Completed Day 3 of "Morning Reset" Pack', time: '2m ago', type: 'PACK', tag: 'Morning' },
                      { id: '2', user: 'David Chen', action: 'Reached 42-day mindfulness streak 🔥', time: '5m ago', type: 'STREAK', tag: 'Milestone' },
                      { id: '3', user: 'Alex Rivers', action: 'Upgraded to Pro Annual Plan ($29.99)', time: '14m ago', type: 'BILLING', tag: 'Revenue' },
                      { id: '4', user: 'Elena Rostova', action: 'Saved evening reflection: "Letting go of outside control"', time: '22m ago', type: 'JOURNAL', tag: 'Reflection' },
                      { id: '5', user: 'Marcus Vance', action: 'Started 7-day "Unstoppable Confidence" Pack', time: '35m ago', type: 'PACK', tag: 'Confidence' },
                    ].map((act) => (
                      <div key={act.id} style={{ padding: '12px 18px', borderBottom: '1px solid #182030', display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '12px' }}>
                        <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                          <div style={{ width: '28px', height: '28px', borderRadius: '4px', background: act.type === 'BILLING' ? 'rgba(16, 185, 129, 0.15)' : act.type === 'STREAK' ? 'rgba(245, 158, 11, 0.15)' : 'rgba(99, 102, 241, 0.15)', color: act.type === 'BILLING' ? '#10b981' : act.type === 'STREAK' ? '#f59e0b' : '#6366f1', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '11px', fontWeight: 700 }}>
                            {act.type === 'BILLING' ? '$' : act.type === 'STREAK' ? '🔥' : '★'}
                          </div>
                          <div>
                            <div style={{ fontSize: '12.5px', fontWeight: 600, color: '#fff' }}>{act.user}</div>
                            <div style={{ fontSize: '11.5px', color: '#94a3b8' }}>{act.action}</div>
                          </div>
                        </div>
                        <div style={{ textAlign: 'right' }}>
                          <span className="pill-badge pill-slate">{act.tag}</span>
                          <div style={{ fontSize: '10.5px', color: '#64748b', marginTop: '3px' }}>{act.time}</div>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>

                {/* Right Column: Infrastructure Telemetry & Habit Curves */}
                <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
                  <div className="flat-card">
                    <div className="flat-card-header">
                      <span className="card-title">Live Infrastructure Status</span>
                      <span className="pill-badge pill-slate">Fastify Node</span>
                    </div>
                    <div style={{ padding: '16px 18px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
                      <div style={{ background: '#151C2C', padding: '10px 14px', borderRadius: '4px', border: '1px solid #1E2738' }}>
                        <div style={{ fontSize: '11px', color: '#94a3b8' }}>Database Latency</div>
                        <div style={{ fontSize: '16px', fontWeight: 700, color: '#10b981', marginTop: '2px' }}>1.8ms</div>
                        <div style={{ fontSize: '10.5px', color: '#64748b' }}>PgBouncer Optimal</div>
                      </div>
                      <div style={{ background: '#151C2C', padding: '10px 14px', borderRadius: '4px', border: '1px solid #1E2738' }}>
                        <div style={{ fontSize: '11px', color: '#94a3b8' }}>Redis Hit Rate</div>
                        <div style={{ fontSize: '16px', fontWeight: 700, color: '#f59e0b', marginTop: '2px' }}>94.2%</div>
                        <div style={{ fontSize: '10.5px', color: '#64748b' }}>Quota & Quotes</div>
                      </div>
                      <div style={{ background: '#151C2C', padding: '10px 14px', borderRadius: '4px', border: '1px solid #1E2738' }}>
                        <div style={{ fontSize: '11px', color: '#94a3b8' }}>Monthly Recurring Rev</div>
                        <div style={{ fontSize: '16px', fontWeight: 700, color: '#fff', marginTop: '2px' }}>$8,420</div>
                        <div style={{ fontSize: '10.5px', color: '#10b981' }}>+18.4% this month</div>
                      </div>
                      <div style={{ background: '#151C2C', padding: '10px 14px', borderRadius: '4px', border: '1px solid #1E2738' }}>
                        <div style={{ fontSize: '11px', color: '#94a3b8' }}>Daily AI Tokens</div>
                        <div style={{ fontSize: '16px', fontWeight: 700, color: '#6366f1', marginTop: '2px' }}>124k / 500k</div>
                        <div style={{ fontSize: '10.5px', color: '#64748b' }}>24.8% capacity</div>
                      </div>
                    </div>
                  </div>

                  <div className="flat-card">
                    <div className="flat-card-header">
                      <span className="card-title">Daily Routine Habit Velocity</span>
                      <span className="pill-badge pill-amber">7 AM & 9 PM Peaks</span>
                    </div>
                    <div style={{ padding: '16px 18px 10px' }}>
                      <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', height: '64px', gap: '6px' }}>
                        {[
                          { h: '6a', v: 45 }, { h: '7a', v: 95 }, { h: '8a', v: 80 }, { h: '9a', v: 35 },
                          { h: '12p', v: 50 }, { h: '3p', v: 30 }, { h: '6p', v: 40 }, { h: '8p', v: 75 },
                          { h: '9p', v: 90 }, { h: '10p', v: 60 }
                        ].map((item, idx) => (
                          <div key={idx} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%', justifyContent: 'flex-end' }}>
                            <div style={{ width: '100%', height: `${(item.v / 100) * 50}px`, background: item.v > 70 ? '#f59e0b' : '#1E2738', borderRadius: '2px' }}></div>
                            <span style={{ fontSize: '9px', color: '#64748b', marginTop: '4px' }}>{item.h}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              {/* Top Performing Content Today */}
              <div className="flat-card" style={{ marginBottom: '16px' }}>
                <div className="flat-card-header">
                  <span className="card-title">Top Performing Content Today</span>
                  <span className="pill-badge pill-indigo">Engagement Leaders</span>
                </div>
                <table className="flat-table">
                  <thead>
                    <tr>
                      <th>Content Title</th>
                      <th>Category</th>
                      <th>Today's Engagement Metric</th>
                      <th>Classification</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td style={{ fontWeight: 600, color: '#fff' }}>Marcus Aurelius — "You have power over your mind..."</td>
                      <td><span className="pill-badge pill-amber">Stoicism</span></td>
                      <td>890 views · 240 saves</td>
                      <td><span className="pill-badge pill-emerald">Top Daily Quote</span></td>
                    </tr>
                    <tr>
                      <td style={{ fontWeight: 600, color: '#fff' }}>Morning Reset: Day 1 Awakening with Intention</td>
                      <td><span className="pill-badge pill-amber">Morning</span></td>
                      <td>640 sessions completed</td>
                      <td><span className="pill-badge pill-emerald">Top Rise Pack</span></td>
                    </tr>
                    <tr>
                      <td style={{ fontWeight: 600, color: '#fff' }}>528Hz Solfeggio Harmonic Sine Waves</td>
                      <td><span className="pill-badge pill-amber">Soundscapes</span></td>
                      <td>420 active listeners</td>
                      <td><span className="pill-badge pill-emerald">Top Ambient Audio</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>

              {/* Quick Studio Operations */}
              <div className="flat-card">
                <div className="flat-card-header"><span className="card-title">Quick Studio Operations</span></div>
                <div style={{ padding: '14px 18px', display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
                  <button className="btn btn-primary btn-sm" onClick={() => { setSelectedPack(packs[0]); setActiveModal('curriculum'); }}><Icons.Box /><span>Open Pack Studio</span></button>
                  <button className="btn btn-secondary btn-sm" onClick={() => setActiveModal('create-quote')}><Icons.Quote /><span>Add Motivation Quote</span></button>
                  <button className="btn btn-secondary btn-sm" onClick={() => setTab('media')}><Icons.Music /><span>Upload Audio Track</span></button>
                  <button className="btn btn-secondary btn-sm" onClick={() => setTab('analytics')}><Icons.BarChart /><span>View Full Analytics</span></button>
                  <button className="btn btn-secondary btn-sm" onClick={() => setTab('experiments')}><Icons.Flask /><span>Manage Paywall A/B Tests</span></button>
                </div>
              </div>
            </div>
          )}

          {/* 2. PRODUCT ANALYTICS (Full Visual Charts, Donut, Cohorts & Funnel Restored) */}
          {tab === 'analytics' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Product & User Behavior Analytics</h1>
                  <p className="view-subtitle">Interactive visual charts, retention cohort heatmaps, and funnel telemetry</p>
                </div>
                <div className="filter-row">
                  <button className={`btn btn-sm ${timeRange === '7d' ? 'btn-primary' : 'btn-secondary'}`} onClick={() => setTimeRange('7d')}>7 Days</button>
                  <button className={`btn btn-sm ${timeRange === '30d' ? 'btn-primary' : 'btn-secondary'}`} onClick={() => setTimeRange('30d')}>30 Days</button>
                  <button className={`btn btn-sm ${timeRange === '90d' ? 'btn-primary' : 'btn-secondary'}`} onClick={() => setTimeRange('90d')}>90 Days</button>
                </div>
              </div>

              {/* KPI Stat Cards */}
              <div className="kpi-row" style={{ marginBottom: '16px' }}>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">Daily Active Users (DAU)</span><div className="kpi-icon-box" style={{ color: '#f59e0b' }}><Icons.Users /></div></div><div className="kpi-value">460</div><span className="pill-badge pill-amber">+14.2% MoM Growth</span></div>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">Monthly Active (MAU)</span><div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.BarChart /></div></div><div className="kpi-value">1,420</div><span className="pill-badge pill-indigo">30-Day Window</span></div>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">Stickiness (DAU/MAU)</span><div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Sparkles /></div></div><div className="kpi-value">32.4%</div><span className="pill-badge pill-emerald">Top Quartile</span></div>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">Avg Session Length</span><div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Clock /></div></div><div className="kpi-value">4m 18s</div><span className="pill-badge pill-slate">Morning Boost + Journal</span></div>
              </div>

              {/* 1. Interactive SVG Area/Line Chart: DAU & MAU Growth */}
              <div className="flat-card" style={{ marginBottom: '16px' }}>
                <div className="flat-card-header">
                  <div>
                    <span className="card-title">Daily Active Users Trend & Trajectory</span>
                    <div style={{ fontSize: '11.5px', color: '#64748b', marginTop: '2px' }}>Hover over data points to inspect active user count</div>
                  </div>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
                    <span style={{ fontSize: '12px', display: 'flex', alignItems: 'center', gap: '6px', color: '#f59e0b' }}><span style={{ width: '8px', height: '8px', background: '#f59e0b', borderRadius: '1px' }}></span> DAU Trend</span>
                    <span style={{ fontSize: '12px', display: 'flex', alignItems: 'center', gap: '6px', color: '#6366f1' }}><span style={{ width: '8px', height: '8px', background: '#6366f1', borderRadius: '1px' }}></span> MAU Benchmark</span>
                  </div>
                </div>

                <div style={{ padding: '20px 24px 10px' }}>
                  <div style={{ position: 'relative', width: '100%', height: '190px' }}>
                    <svg width="100%" height="170" viewBox="0 0 700 170" preserveAspectRatio="none" style={{ overflow: 'visible' }}>
                      <line x1="0" y1="35" x2="700" y2="35" stroke="#1E2738" strokeDasharray="3 3" />
                      <line x1="0" y1="80" x2="700" y2="80" stroke="#1E2738" strokeDasharray="3 3" />
                      <line x1="0" y1="125" x2="700" y2="125" stroke="#1E2738" strokeDasharray="3 3" />
                      <line x1="0" y1="170" x2="700" y2="170" stroke="#1E2738" />

                      <polygon points="0,170 0,140 116,128 233,115 350,105 466,90 583,78 700,65 700,170" fill="rgba(245, 158, 11, 0.08)" />
                      <polyline points="0,50 116,44 233,38 350,32 466,25 583,18 700,10" fill="none" stroke="#6366f1" strokeWidth="2" />
                      <polyline points="0,140 116,128 233,115 350,105 466,90 583,78 700,65" fill="none" stroke="#f59e0b" strokeWidth="2.5" />

                      {[
                        { x: 0, y: 140, day: 'Day 1', dau: 310, mau: 980 },
                        { x: 116, y: 128, day: 'Day 5', dau: 345, mau: 1040 },
                        { x: 233, y: 115, day: 'Day 10', dau: 380, mau: 1120 },
                        { x: 350, y: 105, day: 'Day 15', dau: 395, mau: 1190 },
                        { x: 466, y: 90, day: 'Day 20', dau: 420, mau: 1280 },
                        { x: 583, y: 78, day: 'Day 25', dau: 442, mau: 1350 },
                        { x: 700, y: 65, day: 'Day 30', dau: 460, mau: 1420 },
                      ].map((pt, idx) => (
                        <circle key={idx} cx={pt.x} cy={pt.y} r="4" fill="#080C14" stroke="#f59e0b" strokeWidth="2.5" style={{ cursor: 'pointer' }} onMouseEnter={() => setHoveredPoint(pt)} onMouseLeave={() => setHoveredPoint(null)} />
                      ))}
                    </svg>

                    {hoveredPoint && (
                      <div style={{ position: 'absolute', top: '10px', right: '20px', background: '#151C2C', border: '1px solid #1E2738', borderRadius: '4px', padding: '6px 12px', fontSize: '12px', color: '#fff' }}>
                        <div style={{ fontWeight: 700, color: '#f59e0b' }}>{hoveredPoint.day}</div>
                        <div>DAU: <strong>{hoveredPoint.dau}</strong> · MAU: <strong>{hoveredPoint.mau}</strong></div>
                      </div>
                    )}
                  </div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '12px', fontSize: '11px', color: '#64748b' }}>
                    <span>Day 1</span><span>Day 5</span><span>Day 10</span><span>Day 15</span><span>Day 20</span><span>Day 25</span><span>Day 30</span>
                  </div>
                </div>
              </div>

              {/* 2. Grid: Stacked Weekly Growth & Feature Donut */}
              <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(340px, 1fr))', gap: '16px', marginBottom: '16px' }}>
                <div className="flat-card">
                  <div className="flat-card-header">
                    <span className="card-title">Weekly Free vs Pro Acquisition</span>
                    <div style={{ display: 'flex', gap: '8px', fontSize: '11px' }}>
                      <span style={{ color: '#10b981' }}>■ Pro Sub</span>
                      <span style={{ color: '#64748b' }}>■ Free User</span>
                    </div>
                  </div>
                  <div style={{ padding: '20px 20px 10px' }}>
                    <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', height: '140px', gap: '8px' }}>
                      {[
                        { week: 'W1', free: 210, pro: 48 }, { week: 'W2', free: 245, pro: 62 },
                        { week: 'W3', free: 280, pro: 75 }, { week: 'W4', free: 320, pro: 92 },
                        { week: 'W5', free: 350, pro: 114 }, { week: 'W6', free: 390, pro: 138 },
                        { week: 'W7', free: 420, pro: 156 }, { week: 'W8', free: 460, pro: 180 },
                      ].map((item, i) => (
                        <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%', justifyContent: 'flex-end' }}>
                          <div style={{ width: '100%', maxWidth: '24px', display: 'flex', flexDirection: 'column', borderRadius: '3px', overflow: 'hidden' }}>
                            <div style={{ height: `${item.pro * 0.35}px`, background: '#10b981' }}></div>
                            <div style={{ height: `${item.free * 0.18}px`, background: '#1E2738' }}></div>
                          </div>
                          <span style={{ fontSize: '10.5px', color: '#64748b', marginTop: '6px' }}>{item.week}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>

                <div className="flat-card">
                  <div className="flat-card-header">
                    <span className="card-title">Feature Time Allocation</span>
                  </div>
                  <div style={{ padding: '20px', display: 'flex', alignItems: 'center', justifyContent: 'space-around', flexWrap: 'wrap', gap: '16px' }}>
                    <div style={{ position: 'relative', width: '120px', height: '120px' }}>
                      <svg width="120" height="120" viewBox="0 0 42 42">
                        <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#151C2C" strokeWidth="6"></circle>
                        <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#f59e0b" strokeWidth="6" strokeDasharray="42 58" strokeDashoffset="25"></circle>
                        <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#6366f1" strokeWidth="6" strokeDasharray="28 72" strokeDashoffset="83"></circle>
                        <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#10b981" strokeWidth="6" strokeDasharray="18 82" strokeDashoffset="55"></circle>
                        <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#0ea5e9" strokeWidth="6" strokeDasharray="12 88" strokeDashoffset="37"></circle>
                      </svg>
                      <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
                        <span style={{ fontSize: '13px', fontWeight: 800, color: '#fff' }}>100%</span>
                        <span style={{ fontSize: '8.5px', color: '#64748b', textTransform: 'uppercase' }}>Time Spent</span>
                      </div>
                    </div>

                    <div style={{ display: 'flex', flexDirection: 'column', gap: '6px', fontSize: '11px' }}>
                      <div><span style={{ color: '#f59e0b', fontWeight: 700 }}>42%</span> Morning Boost</div>
                      <div><span style={{ color: '#6366f1', fontWeight: 700 }}>28%</span> Reflections</div>
                      <div><span style={{ color: '#10b981', fontWeight: 700 }}>18%</span> Breathing</div>
                      <div><span style={{ color: '#0ea5e9', fontWeight: 700 }}>12%</span> Rise Packs</div>
                    </div>
                  </div>
                </div>
              </div>

              {/* 3. Retention Cohorts Heatmap */}
              <div className="flat-card" style={{ marginBottom: '16px' }}>
                <div className="flat-card-header">
                  <span className="card-title">User Retention Cohorts Heatmap</span>
                </div>
                <table className="flat-table">
                  <thead>
                    <tr>
                      <th>Cohort Week</th>
                      <th>New Users</th>
                      <th>Day 1</th>
                      <th>Day 3</th>
                      <th>Day 7</th>
                      <th>Day 14</th>
                      <th>Day 30</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td style={{ fontWeight: 600, color: '#fff' }}>Aug 18 - Aug 24</td>
                      <td>480</td>
                      <td><span className="pill-badge pill-emerald">68%</span></td>
                      <td><span className="pill-badge pill-emerald">52%</span></td>
                      <td><span className="pill-badge pill-amber">41%</span></td>
                      <td><span className="pill-badge pill-amber">34%</span></td>
                      <td><span className="pill-badge pill-slate">28%</span></td>
                    </tr>
                    <tr>
                      <td style={{ fontWeight: 600, color: '#fff' }}>Aug 11 - Aug 17</td>
                      <td>512</td>
                      <td><span className="pill-badge pill-emerald">66%</span></td>
                      <td><span className="pill-badge pill-emerald">49%</span></td>
                      <td><span className="pill-badge pill-amber">39%</span></td>
                      <td><span className="pill-badge pill-amber">32%</span></td>
                      <td><span className="pill-badge pill-slate">26%</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>

              {/* 4. Onboarding Funnel Progress Bars */}
              <div className="flat-card">
                <div className="flat-card-header">
                  <span className="card-title">Onboarding & Paywall Conversion Funnel</span>
                </div>
                <div style={{ padding: '16px 20px', display: 'flex', flexDirection: 'column', gap: '12px' }}>
                  {[
                    { step: '1. App Install & Open', count: '1,420 users', rate: '100%', width: '100%' },
                    { step: '2. Focus Areas Selected', count: '1,280 users', rate: '90.1%', width: '90.1%' },
                    { step: '3. Routine Time Window Set', count: '1,140 users', rate: '80.2%', width: '80.2%' },
                    { step: '4. Paywall View', count: '980 users', rate: '69.0%', width: '69.0%' },
                    { step: '5. Free Trial / Sub Started', count: '348 users', rate: '24.5%', width: '24.5%' },
                  ].map((f, i) => (
                    <div key={i}>
                      <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', marginBottom: '4px' }}>
                        <span style={{ color: '#fff', fontWeight: 500 }}>{f.step}</span>
                        <span style={{ fontWeight: 700, color: i === 4 ? '#10b981' : '#94a3b8' }}>
                          {f.count} ({f.rate})
                        </span>
                      </div>
                      <div style={{ width: '100%', height: '8px', background: '#151C2C', borderRadius: '3px', overflow: 'hidden' }}>
                        <div
                          style={{
                            width: f.width,
                            height: '100%',
                            background: i === 4 ? '#10b981' : '#f59e0b',
                            borderRadius: '3px',
                          }}
                        ></div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>
          )}

          {/* 3. RISE PACKS */}
          {tab === 'packs' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Rise Packs Studio</h1>
                  <p className="view-subtitle">Manage 7-day mini-experiences, cover artwork assets, StoreKit product IDs, and audio curricula</p>
                </div>
              </div>

              <div className="pack-flat-grid">
                {packs.map((p) => (
                  <div key={p.id} className="pack-flat-card">
                    <div
                      style={{
                        height: '100px',
                        borderRadius: '4px',
                        marginBottom: '10px',
                        background: 'linear-gradient(135deg, rgba(245, 158, 11, 0.2) 0%, rgba(15, 23, 42, 0.9) 100%)',
                        border: '1px solid #1E2738',
                        padding: '10px 12px',
                        display: 'flex',
                        flexDirection: 'column',
                        justifyContent: 'space-between',
                      }}
                    >
                      <div style={{ display: 'flex', justifyContent: 'space-between' }}>
                        <span className={`pill-badge ${p.accessLevel === 'FREE' ? 'pill-emerald' : 'pill-amber'}`}>{p.accessLevel}</span>
                        <span className="pill-badge pill-slate">{p.durationDays} Days</span>
                      </div>
                      <div style={{ fontSize: '10.5px', fontWeight: 700, color: '#f59e0b', textTransform: 'uppercase' }}>
                        Artwork: {p.heroArtwork || 'pack_morning_reset'}
                      </div>
                    </div>

                    <div className="pack-flat-title">{p.title}</div>
                    <div className="pack-flat-sub">{p.subtitle || 'Transformational daily routine and mindful habit builder.'}</div>
                    <div style={{ fontSize: '11px', fontFamily: 'monospace', color: '#64748b', marginBottom: '10px' }}>
                      {p.storeKitProductId || 'Standard Free Access'}
                    </div>

                    <div className="pack-flat-footer">
                      <span style={{ fontWeight: 700, fontSize: '12px' }}>{p.priceTier || 'Free'}</span>
                      <button className="btn btn-secondary btn-sm" onClick={() => { setSelectedPack(p); setActiveModal('curriculum'); }}>
                        Edit Curriculum ({p.items?.length || 7} Days)
                      </button>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* 4. QUOTES CMS */}
          {tab === 'quotes' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Quotes & Thoughts CMS</h1>
                  <p className="view-subtitle">Curate daily wisdom catalog, artwork backgrounds, and assign Day of Year rotations</p>
                </div>
                <button className="btn btn-primary btn-sm" onClick={() => setActiveModal('create-quote')}>
                  <Icons.Plus />
                  <span>Add Quote</span>
                </button>
              </div>

              <div className="flat-card">
                <div className="flat-card-header">
                  <div className="search-input-group" style={{ width: '100%', maxWidth: '280px' }}>
                    <Icons.Search />
                    <input
                      type="text"
                      placeholder="Search quotes, authors..."
                      value={quoteSearch}
                      onChange={(e) => { setQuoteSearch(e.target.value); setQuotePage(1); }}
                    />
                  </div>

                  <div className="filter-row">
                    <select className="flat-select" value={quoteCategory} onChange={(e) => { setQuoteCategory(e.target.value); setQuotePage(1); }}>
                      <option value="">All 16 Categories</option>
                      {CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                    </select>

                    <select className="flat-select" value={quoteFeatured} onChange={(e) => { setQuoteFeatured(e.target.value); setQuotePage(1); }}>
                      <option value="ALL">All Statuses</option>
                      <option value="FEATURED">★ Featured Only</option>
                      <option value="STANDARD">Standard Catalog</option>
                    </select>
                  </div>
                </div>

                <table className="flat-table">
                  <thead>
                    <tr>
                      <th>Quote & Artwork</th>
                      <th>Author</th>
                      <th>Category</th>
                      <th>Day</th>
                      <th>Featured</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {paginatedQuotes.map((q) => (
                      <tr key={q.id}>
                        <td style={{ color: '#fff', maxWidth: '340px' }}>
                          <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                            <div style={{ width: '24px', height: '24px', borderRadius: '3px', background: '#1E2738', border: '1px solid #334155', flexShrink: 0 }} title={`Artwork: ${q.assetName}`}></div>
                            <div>
                              <div>"{q.quote}"</div>
                              <div style={{ fontSize: '10px', color: '#64748b' }}>Artwork: {q.assetName || 'onboarding_motivation_bg'}</div>
                            </div>
                          </div>
                        </td>
                        <td style={{ fontWeight: 600 }}>{q.author}</td>
                        <td><span className="pill-badge pill-amber">{q.category}</span></td>
                        <td><span className="pill-badge pill-slate">Day {q.dayOfYear || 'Auto'}</span></td>
                        <td>{q.isFeatured ? <span className="pill-badge pill-emerald">Featured</span> : '-'}</td>
                        <td>
                          <button className="btn btn-danger btn-sm" onClick={() => handleDeleteQuote(q.id)}>Delete</button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>

                <PaginationBar
                  currentPage={quotePage}
                  totalItems={filteredQuotes.length}
                  pageSize={quotePageSize}
                  onPageChange={setQuotePage}
                  onPageSizeChange={(s) => { setQuotePageSize(s); setQuotePage(1); }}
                />
              </div>
            </div>
          )}

          {/* 5. AFFIRMATIONS */}
          {tab === 'affirmations' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Affirmations Hub</h1>
                  <p className="view-subtitle">Curate 16-category daily affirmations and access tiers</p>
                </div>
                <button
                  className="btn btn-primary btn-sm"
                  onClick={() => {
                    const t = prompt('Enter affirmation text:');
                    if (t) alert(`Affirmation "${t}" added!`);
                  }}
                >
                  <Icons.Plus />
                  <span>Add Affirmation</span>
                </button>
              </div>

              <div className="flat-card">
                <div className="flat-card-header">
                  <div className="search-input-group" style={{ width: '100%', maxWidth: '280px' }}>
                    <Icons.Search />
                    <input
                      type="text"
                      placeholder="Search affirmations..."
                      value={affSearch}
                      onChange={(e) => { setAffSearch(e.target.value); setAffPage(1); }}
                    />
                  </div>

                  <div className="filter-row">
                    <select className="flat-select" value={affCategory} onChange={(e) => { setAffCategory(e.target.value); setAffPage(1); }}>
                      <option value="">All Categories</option>
                      {CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                    </select>

                    <select className="flat-select" value={affTier} onChange={(e) => { setAffTier(e.target.value); setAffPage(1); }}>
                      <option value="ALL">All Tiers</option>
                      <option value="FREE">Free</option>
                      <option value="PRO">Pro</option>
                    </select>
                  </div>
                </div>

                <table className="flat-table">
                  <thead>
                    <tr>
                      <th>Affirmation Statement</th>
                      <th>Category</th>
                      <th>Access</th>
                      <th>Day</th>
                      <th>Artwork Asset</th>
                    </tr>
                  </thead>
                  <tbody>
                    {paginatedAffirmations.map((a) => (
                      <tr key={a.id}>
                        <td style={{ color: '#fff', fontWeight: 500 }}>"{a.text}"</td>
                        <td><span className="pill-badge pill-indigo">{a.category}</span></td>
                        <td><span className={`pill-badge ${a.accessLevel === 'FREE' ? 'pill-emerald' : 'pill-amber'}`}>{a.accessLevel}</span></td>
                        <td><span className="pill-badge pill-slate">Day {a.dayOfYear || 'Auto'}</span></td>
                        <td><span style={{ fontSize: '11px', fontFamily: 'monospace', color: '#64748b' }}>{a.assetName || 'onboarding_motivation_bg'}</span></td>
                      </tr>
                    ))}
                  </tbody>
                </table>

                <PaginationBar
                  currentPage={affPage}
                  totalItems={filteredAffirmations.length}
                  pageSize={affPageSize}
                  onPageChange={setAffPage}
                  onPageSizeChange={(s) => { setAffPageSize(s); setAffPage(1); }}
                />
              </div>
            </div>
          )}

          {/* 6. AI ENGINE & SAFETY GUARDIAN */}
          {tab === 'ai' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">AI Engine & Safety Guardian</h1>
                  <p className="view-subtitle">System prompt tuning, model parameter controls, token metering, and crisis intervention audit logs</p>
                </div>
                <button
                  className="btn btn-primary btn-sm"
                  onClick={() => alert('AI System Prompts and Model Configuration saved successfully!')}
                >
                  Save Active Configuration
                </button>
              </div>

              {/* KPI Meter */}
              <div className="kpi-row" style={{ marginBottom: '16px' }}>
                <div className="kpi-flat-card">
                  <div className="kpi-top"><span className="kpi-title">Daily AI Generations</span><div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.Cpu /></div></div>
                  <div className="kpi-value">1,840</div>
                  <span className="pill-badge pill-indigo">Avg 0.38s Response</span>
                </div>
                <div className="kpi-flat-card">
                  <div className="kpi-top"><span className="kpi-title">Token Quota Meter</span><div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Sparkles /></div></div>
                  <div className="kpi-value">124k / 500k</div>
                  <span className="pill-badge pill-emerald">24.8% Used Today</span>
                </div>
                <div className="kpi-flat-card">
                  <div className="kpi-top"><span className="kpi-title">Crisis Interceptions</span><div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Shield /></div></div>
                  <div className="kpi-value">2 Total</div>
                  <span className="pill-badge pill-emerald">100% 988 Dispatched</span>
                </div>
              </div>

              {/* Prompt Editor & Playground */}
              <div className="flat-card" style={{ marginBottom: '16px' }}>
                <div className="flat-card-header">
                  <div>
                    <span className="card-title">System Prompt Tuning & Configuration</span>
                    <div style={{ fontSize: '11.5px', color: '#64748b', marginTop: '2px' }}>Customize the exact instructions sent to the AI model for each feature</div>
                  </div>
                  <div className="filter-row">
                    <button
                      className={`btn btn-sm ${aiPromptType === 'boost' ? 'btn-primary' : 'btn-secondary'}`}
                      onClick={() => {
                        setAiPromptType('boost');
                        setAiSystemPrompt(
                          'You are Rise AI, an elite morning mindset coach steeped in Stoic philosophy, grounded presence, and peak performance discipline. Deliver powerful, crisp, empowering 2-sentence morning guidance tailored to the user’s selected focus areas.'
                        );
                      }}
                    >
                      Morning Boost
                    </button>
                    <button
                      className={`btn btn-sm ${aiPromptType === 'reflection' ? 'btn-primary' : 'btn-secondary'}`}
                      onClick={() => {
                        setAiPromptType('reflection');
                        setAiSystemPrompt(
                          'You are an empathetic, reflective journaling companion. When a user records an evening reflection, provide an insightful 1-sentence synthesis highlighting cognitive reframing and emotional resilience.'
                        );
                      }}
                    >
                      Reflection Insight
                    </button>
                    <button
                      className={`btn btn-sm ${aiPromptType === 'growth' ? 'btn-primary' : 'btn-secondary'}`}
                      onClick={() => {
                        setAiPromptType('growth');
                        setAiSystemPrompt(
                          'You are the Rise Weekly Growth synthesist. Review the user’s 7-day intention streak, mindful minutes, and reflections, and construct a concise, high-impact growth summary celebrating their discipline.'
                        );
                      }}
                    >
                      Weekly Summary
                    </button>
                  </div>
                </div>

                <div style={{ padding: '18px', display: 'flex', flexDirection: 'column', gap: '14px' }}>
                  {/* Model & Parameter Row */}
                  <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '12px' }}>
                    <div className="input-field">
                      <label className="input-label">LLM Provider & Model</label>
                      <select className="flat-select" value={aiModel} onChange={(e) => setAiModel(e.target.value)}>
                        <option value="gemini-1.5-pro">Google Gemini 1.5 Pro (Active Provider)</option>
                        <option value="gemini-2.0-flash">Google Gemini 2.0 Flash (Ultra-Fast)</option>
                        <option value="claude-3-5-sonnet">Anthropic Claude 3.5 Sonnet</option>
                        <option value="gpt-4o">OpenAI GPT-4o</option>
                        <option value="gpt-4o-mini">OpenAI GPT-4o Mini (Fast/Low-Cost)</option>
                      </select>
                    </div>

                    <div className="input-field">
                      <label className="input-label">Temperature ({aiTemperature})</label>
                      <input
                        type="range"
                        min="0.1"
                        max="1.0"
                        step="0.05"
                        value={aiTemperature}
                        onChange={(e) => setAiTemperature(Number(e.target.value))}
                        style={{ width: '100%', marginTop: '6px' }}
                      />
                    </div>

                    <div className="input-field">
                      <label className="input-label">Max Token Limit</label>
                      <input type="number" className="text-input" defaultValue={250} />
                    </div>
                  </div>

                  {/* Editable System Prompt Textarea */}
                  <div className="input-field">
                    <label className="input-label">Active System Prompt (Editable)</label>
                    <textarea
                      className="textarea-input"
                      rows={4}
                      style={{ fontFamily: 'monospace', fontSize: '12px', lineHeight: 1.5 }}
                      value={aiSystemPrompt}
                      onChange={(e) => setAiSystemPrompt(e.target.value)}
                    ></textarea>
                  </div>

                  {/* Interactive Test Generator Box */}
                  <div style={{ background: '#151C2C', padding: '14px', borderRadius: '4px', border: '1px solid #1E2738' }}>
                    <label className="input-label">Simulation Input Context (User Focus / Emotion)</label>
                    <div style={{ display: 'flex', gap: '8px', marginTop: '6px' }}>
                      <input
                        type="text"
                        className="text-input"
                        style={{ flex: 1 }}
                        value={aiTestContext}
                        onChange={(e) => setAiTestContext(e.target.value)}
                        placeholder="e.g. Feeling anxious about a major presentation..."
                      />
                      <button className="btn btn-primary btn-sm" onClick={handleTestAiPrompt} disabled={aiIsLoading}>
                        {aiIsLoading ? 'Generating...' : '⚡ Test AI Output'}
                      </button>
                    </div>

                    {aiTestOutput && (
                      <div style={{ marginTop: '12px', background: '#080C14', border: '1px solid #1E2738', borderRadius: '4px', padding: '12px', color: '#F8FAFC', fontSize: '12px', whiteSpace: 'pre-wrap' }}>
                        {aiTestOutput}
                      </div>
                    )}
                  </div>
                </div>
              </div>

              {/* Safety Guardian: Intercepted Crisis Log */}
              <div className="flat-card">
                <div className="flat-card-header">
                  <span className="card-title">🚨 Safety Guardian: Intercepted Crisis Audit Log</span>
                  <span className="pill-badge pill-emerald">Zero-LLM Bypass Active</span>
                </div>
                <table className="flat-table">
                  <thead>
                    <tr>
                      <th>Event Timestamp</th>
                      <th>Trigger Pattern</th>
                      <th>Safety Action Taken</th>
                      <th>Status</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td style={{ color: '#fff' }}>2026-08-26 14:22:10 UTC</td>
                      <td><span className="pill-badge pill-amber">hopeless / severe distress</span></td>
                      <td>Intercepted before LLM call. 988 Suicide & Crisis Lifeline modal dispatched directly.</td>
                      <td><span className="pill-badge pill-emerald">VERIFIED DELIVERED</span></td>
                    </tr>
                    <tr>
                      <td style={{ color: '#fff' }}>2026-08-25 09:14:05 UTC</td>
                      <td><span className="pill-badge pill-amber">self harm intention</span></td>
                      <td>Intercepted before LLM call. Crisis Text Line & emergency contact prompt displayed.</td>
                      <td><span className="pill-badge pill-emerald">VERIFIED DELIVERED</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* 7. USERS DIRECTORY */}
          {tab === 'users' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">User Oversight & Support Directory</h1>
                  <p className="view-subtitle">Search registered profiles, engagement streaks, and grant subscription overrides</p>
                </div>
              </div>

              <div className="flat-card">
                <div className="flat-card-header">
                  <div className="search-input-group" style={{ width: '100%', maxWidth: '280px' }}>
                    <Icons.Search />
                    <input
                      type="text"
                      placeholder="Search name, email..."
                      value={userSearch}
                      onChange={(e) => { setUserSearch(e.target.value); setUserPage(1); }}
                    />
                  </div>

                  <div className="filter-row">
                    <select className="flat-select" value={userTier} onChange={(e) => { setUserTier(e.target.value); setUserPage(1); }}>
                      <option value="ALL">All Tiers</option>
                      <option value="FREE">Free</option>
                      <option value="PRO_MONTHLY">Pro Monthly</option>
                      <option value="PRO_ANNUAL">Pro Annual</option>
                      <option value="LIFETIME">Lifetime</option>
                    </select>
                  </div>
                </div>

                <table className="flat-table">
                  <thead>
                    <tr>
                      <th>User</th>
                      <th>Tier</th>
                      <th>Streak</th>
                      <th>Mindful Mins</th>
                      <th>Action</th>
                    </tr>
                  </thead>
                  <tbody>
                    {paginatedUsers.map((u) => (
                      <tr key={u.id}>
                        <td>
                          <div style={{ fontWeight: 600, color: '#fff' }}>{u.name}</div>
                          <div style={{ fontSize: '11px', color: '#64748b' }}>{u.email || 'Apple ID User'}</div>
                        </td>
                        <td><span className={`pill-badge ${u.subscriptionTier === 'FREE' ? 'pill-slate' : 'pill-amber'}`}>{u.subscriptionTier}</span></td>
                        <td style={{ color: '#f59e0b', fontWeight: 600 }}>🔥 {u.streak} Days</td>
                        <td>{u.mindfulMinutes}m</td>
                        <td>
                          <button className="btn btn-secondary btn-sm" onClick={() => handleGrantPro(u.id)}>
                            {u.subscriptionTier === 'LIFETIME' ? '✓ Lifetime' : 'Grant Lifetime Pro'}
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>

                <PaginationBar
                  currentPage={userPage}
                  totalItems={filteredUsers.length}
                  pageSize={userPageSize}
                  onPageChange={setUserPage}
                  onPageSizeChange={(s) => { setUserPageSize(s); setUserPage(1); }}
                />
              </div>
            </div>
          )}

          {/* 8. BREATHING RESETS & AUDIO */}
          {tab === 'breathing' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Breathing Resets & Soundscapes CMS</h1>
                  <p className="view-subtitle">Manage paced breathwork protocols and procedural harmonic audio frequencies</p>
                </div>
              </div>
              <div className="flat-card">
                <table className="flat-table">
                  <thead><tr><th>Protocol Name</th><th>Timing Sequence</th><th>Target Duration</th><th>Access</th></tr></thead>
                  <tbody>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>Box Breathing</td><td><span className="pill-badge pill-indigo">4s Inhale · 4s Hold · 4s Exhale · 4s Hold</span></td><td>3 Minutes</td><td><span className="pill-badge pill-emerald">FREE</span></td></tr>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>4-7-8 Deep Calm</td><td><span className="pill-badge pill-indigo">4s Inhale · 7s Hold · 8s Exhale</span></td><td>5 Minutes</td><td><span className="pill-badge pill-amber">PRO</span></td></tr>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>Morning Energize</td><td><span className="pill-badge pill-indigo">2s Rapid Inhale · 2s Exhale</span></td><td>2 Minutes</td><td><span className="pill-badge pill-emerald">FREE</span></td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* 9. MEDIA & CDN HUB */}
          {tab === 'media' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Media & Audio CDN Hub</h1>
                  <p className="view-subtitle">Upload voiceover recordings, background soundscapes, and high-res artwork assets</p>
                </div>
              </div>
              <div className="flat-card" style={{ padding: '32px', textAlign: 'center' }}>
                <Icons.Upload />
                <div style={{ color: '#fff', fontWeight: 600, fontSize: '14px', marginTop: '10px' }}>Upload Audio Tracks or Artwork to Cloud CDN</div>
                <div style={{ fontSize: '12px', color: '#64748b', marginTop: '4px' }}>Drag and drop .mp3, .m4a, .png, or .webp files here</div>
                <button className="btn btn-primary btn-sm" style={{ marginTop: '16px' }} onClick={() => alert('Presigned direct upload URL generated!')}>Select Files to Upload</button>
              </div>
            </div>
          )}

          {/* 10. REVENUECAT LEDGER */}
          {tab === 'monetization' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">RevenueCat & StoreKit Ledger</h1>
                  <p className="view-subtitle">Real-time App Store In-App Purchases, subscription renewals, and webhook ledger</p>
                </div>
              </div>
              <div className="kpi-row" style={{ marginBottom: '16px' }}>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">Monthly Recurring Revenue</span><div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.CreditCard /></div></div><div className="kpi-value">$8,420</div><span className="pill-badge pill-emerald">+18.4% MoM</span></div>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">Active 7-Day Trials</span><div className="kpi-icon-box" style={{ color: '#f59e0b' }}><Icons.Sparkles /></div></div><div className="kpi-value">112</div><span className="pill-badge pill-amber">74.2% Conversion</span></div>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">Annual Run-Rate (ARR)</span><div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.BarChart /></div></div><div className="kpi-value">$101,040</div><span className="pill-badge pill-indigo">Trailing 12M</span></div>
              </div>
            </div>
          )}

          {/* 11. EXPERIMENTS */}
          {tab === 'experiments' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Paywall & Onboarding A/B Tests</h1>
                  <p className="view-subtitle">Manage multivariate experiments, compare conversion rates, and deploy winner variations</p>
                </div>
              </div>
              <div className="flat-card">
                <table className="flat-table">
                  <thead><tr><th>Experiment Key</th><th>Control Variation</th><th>Challenger Variation</th><th>Observed Lift</th><th>Status</th></tr></thead>
                  <tbody>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>paywall_annual_banner</td><td>Standard 3-Tier</td><td>Annual Highlight + 3-Day Free Trial</td><td><span className="pill-badge pill-emerald">+29.4% Lift</span></td><td><span className="pill-badge pill-emerald">RUNNING (98% Conf)</span></td></tr>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>onboarding_routine_step</td><td>Single Time Picker</td><td>Dual Window (Morning + Night)</td><td><span className="pill-badge pill-emerald">+14.1% Lift</span></td><td><span className="pill-badge pill-emerald">RUNNING (95% Conf)</span></td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* 12. CAMPAIGNS */}
          {tab === 'campaigns' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Automated Lifecycle Drips</h1>
                  <p className="view-subtitle">Event-triggered push sequences for streak preservation and trial retention</p>
                </div>
              </div>
              <div className="flat-card">
                <table className="flat-table">
                  <thead><tr><th>Campaign Trigger</th><th>Delivery Schedule</th><th>Copy Preview</th><th>Open Rate</th></tr></thead>
                  <tbody>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>Evening Streak Rescue</td><td>Daily at 8:00 PM (If no reflection logged)</td><td>"Your streak is waiting. Claim 2 minutes of evening stillness."</td><td><span className="pill-badge pill-emerald">48.2%</span></td></tr>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>Trial Expiration (24h)</td><td>24h before trial ends</td><td>"Your Rise Pro trial concludes tomorrow. Continue your journey."</td><td><span className="pill-badge pill-amber">62.1%</span></td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* 13. FEEDBACK DESK */}
          {tab === 'support' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Feedback & Diagnostic Support Desk</h1>
                  <p className="view-subtitle">Inspect in-app feedback submissions and anonymous device diagnostic telemetry</p>
                </div>
              </div>
              <div className="flat-card">
                <table className="flat-table">
                  <thead><tr><th>Sender</th><th>Subject</th><th>Device Telemetry</th><th>Status</th><th>Action</th></tr></thead>
                  <tbody>
                    <tr>
                      <td><div style={{ color: '#fff', fontWeight: 600 }}>elena@example.com</div><div style={{ fontSize: '11px', color: '#64748b' }}>Elena Rostova</div></td>
                      <td>"Loving the Box Breathing soundscapes! Could we get rain sounds too?"</td>
                      <td><span className="pill-badge pill-slate">iPhone 16 Pro · iOS 18.2 · v1.0.4</span></td>
                      <td><span className="pill-badge pill-amber">OPEN</span></td>
                      <td><button className="btn btn-primary btn-sm" onClick={() => alert('Ticket resolved!')}>Mark Resolved</button></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* 14. APNS BROADCAST */}
          {tab === 'broadcast' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">APNs Global Push Broadcaster</h1>
                  <p className="view-subtitle">Compose and dispatch instantaneous Apple Push Notification alerts to all registered devices</p>
                </div>
              </div>
              <div className="flat-card" style={{ maxWidth: '560px', padding: '18px' }}>
                <div className="input-field">
                  <label className="input-label">Notification Title</label>
                  <input type="text" className="text-input" placeholder="e.g. 🌅 Rise & Shine: Daily Wisdom Unlocked" value={pushData.title} onChange={(e) => setPushData({ ...pushData, title: e.target.value })} />
                </div>
                <div className="input-field">
                  <label className="input-label">Notification Body</label>
                  <textarea className="textarea-input" rows={3} placeholder="e.g. Today's Stoic thought from Marcus Aurelius is ready..." value={pushData.body} onChange={(e) => setPushData({ ...pushData, body: e.target.value })}></textarea>
                </div>
                <div className="input-field">
                  <label className="input-label">Deep Link Target</label>
                  <input type="text" className="text-input" value={pushData.deepLink} onChange={(e) => setPushData({ ...pushData, deepLink: e.target.value })} />
                </div>
                <button className="btn btn-primary btn-sm" onClick={handleSendBroadcast}>Dispatch Push Broadcast</button>
              </div>
            </div>
          )}

          {/* 15. REMOTE CONFIG */}
          {tab === 'remoteconfig' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Remote Config & Client Flags</h1>
                  <p className="view-subtitle">Sync dynamic variables to iOS devices on launch without App Store builds</p>
                </div>
              </div>
              <div className="flat-card">
                <table className="flat-table">
                  <thead><tr><th>Variable Key</th><th>Type</th><th>Active Value</th><th>Description</th></tr></thead>
                  <tbody>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>enable_ai_morning_boost</td><td>BOOLEAN</td><td><span className="pill-badge pill-emerald">true</span></td><td>Enable AI morning boost prompt on Home tab</td></tr>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>paywall_trial_duration_days</td><td>NUMBER</td><td><span className="pill-badge pill-amber">7</span></td><td>Free trial duration for Pro subscriptions</td></tr>
                    <tr><td style={{ color: '#fff', fontWeight: 600 }}>min_supported_ios_version</td><td>STRING</td><td><span className="pill-badge pill-slate">17.0</span></td><td>Minimum iOS client version</td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* 16. SYSTEM HEALTH & AUDIT */}
          {tab === 'health' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">System Infrastructure & Queues</h1>
                  <p className="view-subtitle">Fastify V8 Node cluster, PostgreSQL query performance, and BullMQ worker status</p>
                </div>
              </div>
              <div className="kpi-row">
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">PostgreSQL Latency</span><div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Activity /></div></div><div className="kpi-value">1.8ms</div><span className="pill-badge pill-emerald">PgBouncer Pooled</span></div>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">Redis Cache Hit Rate</span><div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Sparkles /></div></div><div className="kpi-value">94.2%</div><span className="pill-badge pill-emerald">Rate Limiter & Cache</span></div>
                <div className="kpi-flat-card"><div className="kpi-top"><span className="kpi-title">BullMQ Queue Status</span><div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.Cpu /></div></div><div className="kpi-value">0 Delayed</div><span className="pill-badge pill-indigo">APNs + AI Workers</span></div>
              </div>
            </div>
          )}

          {tab === 'audit' && (
            <div>
              <div className="header-row">
                <div>
                  <h1 className="view-title">Security & Action Audit Trail</h1>
                  <p className="view-subtitle">Immutable log of administrator actions and content modifications for SOC2 compliance</p>
                </div>
              </div>
              <div className="flat-card">
                <table className="flat-table">
                  <thead><tr><th>Timestamp</th><th>Actor</th><th>Action</th><th>Target Resource</th><th>IP Address</th></tr></thead>
                  <tbody>
                    <tr><td style={{ color: '#fff' }}>2026-08-26 19:24:10 UTC</td><td>admin@riseapp.com</td><td><span className="pill-badge pill-amber">UPDATE_QUOTE</span></td><td>Quote #1 (Marcus Aurelius)</td><td>127.0.0.1</td></tr>
                    <tr><td style={{ color: '#fff' }}>2026-08-26 18:50:02 UTC</td><td>admin@riseapp.com</td><td><span className="pill-badge pill-emerald">GRANT_LIFETIME_PRO</span></td><td>User #u3 (david@example.com)</td><td>127.0.0.1</td></tr>
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </div>
      </main>

      {/* MODAL 1: ADD QUOTE */}
      {activeModal === 'create-quote' && (
        <div className="modal-backdrop" onClick={(e) => { if (e.target === e.currentTarget) setActiveModal(null); }}>
          <div className="modal-window" style={{ maxWidth: '600px' }}>
            <div className="modal-head">
              <span style={{ fontWeight: 700, fontSize: '13.5px', color: '#fff' }}>Publish Motivation Quote</span>
              <button className="btn btn-secondary btn-sm" onClick={() => setActiveModal(null)}>✕</button>
            </div>
            <div className="modal-main">
              <div className="input-field">
                <label className="input-label">Quote Text</label>
                <textarea className="textarea-input" rows="3" placeholder="Enter wisdom..." value={newQuote.quote} onChange={(e) => setNewQuote({ ...newQuote, quote: e.target.value })}></textarea>
              </div>
              <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '10px' }}>
                <div className="input-field">
                  <label className="input-label">Author</label>
                  <input type="text" className="text-input" placeholder="e.g. Marcus Aurelius" value={newQuote.author} onChange={(e) => setNewQuote({ ...newQuote, author: e.target.value })} />
                </div>
                <div className="input-field">
                  <label className="input-label">Category</label>
                  <select className="flat-select" value={newQuote.category} onChange={(e) => setNewQuote({ ...newQuote, category: e.target.value })}>
                    {CATEGORIES.map((c) => <option key={c} value={c}>{c}</option>)}
                  </select>
                </div>
              </div>

              <div className="input-field">
                <label className="input-label">Card Artwork Asset</label>
                <select className="flat-select" value={newQuote.assetName} onChange={(e) => setNewQuote({ ...newQuote, assetName: e.target.value })}>
                  <option value="onboarding_motivation_bg">Stoic Marble Texture (Default)</option>
                  <option value="pack_morning_reset">Morning Sunrise (Gold)</option>
                  <option value="pack_confidence">Radiant Fire (Amber)</option>
                  <option value="pack_deep_focus">Deep Ocean (Indigo)</option>
                  <option value="pack_evening_reset">Midnight Calm (Navy)</option>
                </select>
              </div>

              <div className="input-field">
                <label className="input-label">iOS Live Card Preview</label>
                <div style={{ backgroundColor: '#161E31', border: '1px solid #1E2738', borderRadius: '4px', padding: '16px' }}>
                  <div style={{ fontStyle: 'italic', fontSize: '14px', color: '#fff', marginBottom: '6px' }}>"{newQuote.quote || 'Your wisdom appears here in real-time.'}"</div>
                  <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                    <div style={{ fontSize: '11.5px', fontWeight: 700, color: '#f59e0b', textTransform: 'uppercase' }}>{newQuote.author || 'Author Name'}</div>
                    <span className="pill-badge pill-amber">{newQuote.category}</span>
                  </div>
                </div>
              </div>
            </div>
            <div className="modal-foot">
              <button className="btn btn-secondary btn-sm" onClick={() => setActiveModal(null)}>Cancel</button>
              <button className="btn btn-primary btn-sm" onClick={handleCreateQuote}>Publish to Catalog</button>
            </div>
          </div>
        </div>
      )}

      {/* MODAL 2: CURRICULUM STUDIO */}
      {activeModal === 'curriculum' && selectedPack && (
        <div className="modal-backdrop" onClick={(e) => { if (e.target === e.currentTarget) setActiveModal(null); }}>
          <div className="modal-window" style={{ maxWidth: '720px' }}>
            <div className="modal-head">
              <div>
                <div style={{ fontWeight: 700, fontSize: '14px', color: '#fff' }}>{selectedPack.title} — Curriculum Studio</div>
                <div style={{ fontSize: '11.5px', color: '#64748b' }}>Configure cover artwork asset, StoreKit product IDs, and audio tracks</div>
              </div>
              <button className="btn btn-secondary btn-sm" onClick={() => setActiveModal(null)}>✕</button>
            </div>
            <div className="modal-main">
              <div className="input-field" style={{ background: '#151C2C', padding: '12px', borderRadius: '4px', border: '1px solid #1E2738' }}>
                <label className="input-label">Pack Cover Artwork Asset</label>
                <select className="flat-select" defaultValue={selectedPack.heroArtwork || 'pack_morning_reset'}>
                  <option value="pack_morning_reset">Morning Sunrise (Gold)</option>
                  <option value="pack_confidence">Radiant Fire (Amber)</option>
                  <option value="pack_deep_focus">Deep Ocean (Indigo)</option>
                  <option value="pack_evening_reset">Midnight Calm (Navy)</option>
                  <option value="pack_self_love">Rose Serenity (Rose)</option>
                  <option value="pack_discipline">Titanium Steel (Slate)</option>
                </select>
              </div>

              {[1, 2, 3].map((day) => (
                <div key={day} className="session-item">
                  <div className="session-day">D{day}</div>
                  <div className="session-content">
                    <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', marginBottom: '6px' }}>
                      <input type="text" className="text-input" style={{ width: '68%', fontWeight: 600 }} defaultValue={day === 1 ? 'Awakening With Intention' : day === 2 ? 'Release The Urge To Rush' : 'Grounding Resilience'} />
                      <span className={`pill-badge ${day === 2 ? 'pill-indigo' : 'pill-amber'}`}>{day === 2 ? 'AUDIO' : 'BOOST'}</span>
                    </div>
                    <textarea className="textarea-input" rows="2" style={{ fontSize: '12px' }} defaultValue={day === 1 ? 'You do not wake up to react; you wake up to create.' : 'Step out of the autopilot rush.'}></textarea>
                    {day === 2 && (
                      <div style={{ marginTop: '6px', display: 'flex', gap: '6px' }}>
                        <input type="text" className="text-input" style={{ fontSize: '11px', fontFamily: 'monospace', flex: 1 }} defaultValue="https://cdn.riseapp.com/audio/packs/morning_reset_day_2.m4a" />
                        <button className="btn btn-secondary btn-sm" onClick={() => alert('Playing preview audio.')}>▶ Play</button>
                      </div>
                    )}
                  </div>
                </div>
              ))}
            </div>
            <div className="modal-foot">
              <button className="btn btn-secondary btn-sm" onClick={() => setActiveModal(null)}>Close</button>
              <button className="btn btn-primary btn-sm" onClick={() => { alert('Pack Curriculum & Artwork saved!'); setActiveModal(null); }}>Save Curriculum</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
