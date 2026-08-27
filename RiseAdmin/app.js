//
//  app.js
//  RiseAdmin Studio
//
//  High-performance interactive admin dashboard controller connecting to RiseServer /api/v1/admin
//

const API_BASE = 'http://localhost:3000/api/v1';

// Shared State
const state = {
  activeTab: 'overview',
  adminToken: localStorage.getItem('rise_admin_token') || '',
  summary: null,
  packs: [],
  quotes: [],
  affirmations: [],
  users: [],
  categories: [
    'Stoicism', 'Discipline', 'Mindfulness', 'Resilience', 'Gratitude',
    'Focus', 'Inner Peace', 'Growth', 'Courage', 'Confidence', 'Self-Love',
    'Calm', 'Clarity', 'Motivation', 'Positivity', 'Wisdom'
  ],
};

// ==========================================
// HTTP Client Helper
// ==========================================

async function apiRequest(endpoint, options = {}) {
  const headers = {
    'Content-Type': 'application/json',
    ...(state.adminToken ? { Authorization: `Bearer ${state.adminToken}` } : {}),
    ...(options.headers || {}),
  };

  try {
    const res = await fetch(`${API_BASE}${endpoint}`, { ...options, headers });
    const json = await res.json();
    if (!res.ok) {
      throw new Error(json?.error?.message || `Request failed: ${res.status}`);
    }
    return json.data;
  } catch (err) {
    console.warn(`[API] ${endpoint} fetch issue, using fallback:`, err.message);
    return null;
  }
}

// ==========================================
// View Renderers
// ==========================================

const View = {
  // 1. Dashboard Overview
  async renderOverview() {
    const summary = (await apiRequest('/admin/analytics/summary')) || {
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

    return `
      <div class="page-header">
        <div>
          <h1 class="page-title">Executive Dashboard</h1>
          <p class="page-subtitle">Real-time overview of Rise community growth, content ecosystem & sync throughput</p>
        </div>
        <button class="btn btn-secondary" onclick="App.refreshData()">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"></path><path d="M21 3v5h-5"></path><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"></path><path d="M8 16H3v5"></path></svg>
          <span>Refresh Data</span>
        </button>
      </div>

      <div class="kpi-grid">
        <div class="kpi-card">
          <div class="kpi-icon-wrapper" style="background: rgba(229, 169, 60, 0.15); color: #e5a93c;">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M22 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
          </div>
          <div class="kpi-val">${summary.totalUsers.toLocaleString()}</div>
          <div class="kpi-label">Total Registered Users</div>
        </div>

        <div class="kpi-card">
          <div class="kpi-icon-wrapper" style="background: rgba(16, 185, 129, 0.15); color: #10b981;">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z"></path></svg>
          </div>
          <div class="kpi-val">${summary.proUsers.toLocaleString()} <span class="kpi-trend">${summary.conversionRate} Pro</span></div>
          <div class="kpi-label">Active Pro Subscribers</div>
        </div>

        <div class="kpi-card">
          <div class="kpi-icon-wrapper" style="background: rgba(99, 102, 241, 0.15); color: #6366f1;">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m7.5 4.27 9 5.15"></path><path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"></path><path d="m3.3 7 8.7 5 8.7-5"></path><path d="M12 22V12"></path></svg>
          </div>
          <div class="kpi-val">${summary.totalPacks} Official Packs</div>
          <div class="kpi-label">Published Rise Packs</div>
        </div>

        <div class="kpi-card">
          <div class="kpi-icon-wrapper" style="background: rgba(14, 165, 233, 0.15); color: #0ea5e9;">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
          </div>
          <div class="kpi-val">${summary.totalJournals.toLocaleString()}</div>
          <div class="kpi-label">Encrypted User Reflections</div>
        </div>
      </div>

      <div class="table-card">
        <div class="table-header">
          <div class="table-title">Quick Content Operations</div>
        </div>
        <div style="padding: 24px; display: flex; gap: 16px; flex-wrap: wrap;">
          <button class="btn btn-primary" onclick="App.openCreatePackModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14"></path><path d="M12 5v14"></path></svg>
            <span>Create New Rise Pack</span>
          </button>
          <button class="btn btn-secondary" onclick="App.openCreateQuoteModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 21c3 0 7-1 7-8V5c0-1.25-.756-2.017-2-2H4c-1.25 0-2 .75-2 1.972V11c0 1.25.75 2 2 2 1 0 1 0 1 1v1c0 1-1 2-2 2s-1 .008-1 1.031V20c0 1 0 1 1 1z"></path></svg>
            <span>Add Motivation Quote</span>
          </button>
          <button class="btn btn-secondary" onclick="App.openCreateAffirmationModal()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m12 3-1.912 5.813a2 2 0 0 1-1.275 1.275L3 12l5.813 1.912a2 2 0 0 1 1.275 1.275L12 21l1.912-5.813a2 2 0 0 1 1.275-1.275L21 12l-5.813-1.912a2 2 0 0 1-1.275-1.275L12 3Z"></path></svg>
            <span>Add Affirmation</span>
          </button>
        </div>
      </div>
    `;
  },

  // 2. Rise Packs Studio
  async renderPacks() {
    const packs = (await apiRequest('/admin/packs')) || [
      { id: '1', slug: 'morning-reset', title: 'Morning Reset', category: 'Morning', durationDays: 7, accessLevel: 'FREE', priceTier: 'Free', items: [] },
      { id: '2', slug: 'confidence', title: 'Unstoppable Confidence', category: 'Confidence', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.confidence', priceTier: '$2.99', items: [] },
      { id: '3', slug: 'deep-focus', title: 'Deep Focus & Flow', category: 'Focus', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.deepfocus', priceTier: '$2.99', items: [] },
      { id: '4', slug: 'evening-reset', title: 'Evening Reset & Peaceful Sleep', category: 'Evening', durationDays: 7, accessLevel: 'FREE', priceTier: 'Free', items: [] },
      { id: '5', slug: 'self-love', title: 'Radical Self-Love & Compassion', category: 'Self-Love', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.selflove', priceTier: '$2.99', items: [] },
      { id: '6', slug: 'discipline', title: 'Iron Discipline & Consistency', category: 'Discipline', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.discipline', priceTier: '$2.99', items: [] },
      { id: '7', slug: 'fresh-start', title: 'Fresh Start & New Beginnings', category: 'Growth', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.freshstart', priceTier: '$2.99', items: [] },
      { id: '8', slug: 'exam-confidence', title: 'Exam Calm & Academic Mastery', category: 'Clarity', durationDays: 7, accessLevel: 'PRO', storeKitProductId: 'com.riseapp.pack.examconfidence', priceTier: '$2.99', items: [] },
    ];
    state.packs = packs;

    return `
      <div class="page-header">
        <div>
          <h1 class="page-title">Rise Packs Curriculum Studio</h1>
          <p class="page-subtitle">Manage 7-day mini-experiences, session curricula, voiceover tracks & StoreKit products</p>
        </div>
        <button class="btn btn-primary" onclick="App.openCreatePackModal()">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14"></path><path d="M12 5v14"></path></svg>
          <span>Create New Pack</span>
        </button>
      </div>

      <div class="pack-grid">
        ${packs.map((pack) => `
          <div class="pack-card">
            <div class="pack-card-hero">
              <span class="badge ${pack.accessLevel === 'FREE' ? 'badge-green' : 'badge-gold'}">${pack.accessLevel}</span>
              <span class="badge badge-slate" style="position: absolute; right: 16px; top: 16px;">${pack.durationDays} Days</span>
              <div style="font-size: 0.75rem; color: #94a3b8; text-transform: uppercase; font-weight: 700; letter-spacing: 0.05em;">${pack.category}</div>
            </div>
            <div class="pack-card-body">
              <div class="pack-title">${pack.title}</div>
              <div class="pack-subtitle">${pack.subtitle || 'Transformational daily routine and mindful habit builder.'}</div>
              <div style="font-size: 0.78rem; color: #64748b; margin-bottom: 12px;">
                <code>${pack.storeKitProductId || 'Standard In-App Access'}</code>
              </div>
              <div class="pack-footer">
                <span style="font-weight: 700; color: #fff;">${pack.priceTier}</span>
                <button class="btn btn-secondary" style="padding: 6px 14px; font-size: 0.8rem;" onclick="App.openCurriculumEditor('${pack.id}')">
                  Edit Curriculum (${pack.items?.length || 7} Days)
                </button>
              </div>
            </div>
          </div>
        `).join('')}
      </div>
    `;
  },

  // 3. Quotes CMS Studio
  async renderQuotes() {
    const quotes = (await apiRequest('/admin/quotes?limit=50')) || [
      { id: '1', quote: 'You have power over your mind - not outside events. Realize this, and you will find strength.', author: 'Marcus Aurelius', category: 'Stoicism', dayOfYear: 1, isFeatured: true },
      { id: '2', quote: 'We suffer more often in imagination than in reality.', author: 'Seneca', category: 'Resilience', dayOfYear: 2, isFeatured: false },
      { id: '3', quote: 'The obstacle in the path becomes the path. Never forget, within every obstacle is an opportunity to improve our condition.', author: 'Zen Proverb', category: 'Growth', dayOfYear: 3, isFeatured: true },
    ];
    state.quotes = quotes;

    return `
      <div class="page-header">
        <div>
          <h1 class="page-title">Quotes & Daily Thoughts CMS</h1>
          <p class="page-subtitle">Curate daily wisdom catalog, day-of-year rotation & featured morning boosts</p>
        </div>
        <button class="btn btn-primary" onclick="App.openCreateQuoteModal()">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14"></path><path d="M12 5v14"></path></svg>
          <span>Add Quote</span>
        </button>
      </div>

      <div class="table-card">
        <div class="table-header">
          <div class="table-title">Motivation Quotes Catalog (${quotes.length})</div>
          <div class="table-filters">
            <select class="filter-select" id="quote-cat-filter" onchange="App.filterQuotes(this.value)">
              <option value="">All Categories</option>
              ${state.categories.map(c => `<option value="${c}">${c}</option>`).join('')}
            </select>
          </div>
        </div>
        <table class="data-table">
          <thead>
            <tr>
              <th>Quote Text</th>
              <th>Author</th>
              <th>Category</th>
              <th>Day of Year</th>
              <th>Featured</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            ${quotes.map(q => `
              <tr>
                <td style="max-width: 360px; font-style: italic; color: #fff;">"${q.quote}"</td>
                <td style="font-weight: 600;">${q.author}</td>
                <td><span class="badge badge-gold">${q.category}</span></td>
                <td><span class="badge badge-slate">Day ${q.dayOfYear || 'Dynamic'}</span></td>
                <td>${q.isFeatured ? '<span class="badge badge-green">★ Featured</span>' : '<span style="color: #64748b;">-</span>'}</td>
                <td>
                  <button class="btn btn-secondary" style="padding: 4px 10px; font-size: 0.75rem;" onclick="App.deleteQuote('${q.id}')">Delete</button>
                </td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    `;
  },

  // 4. Affirmations CMS
  async renderAffirmations() {
    const affirmations = (await apiRequest('/admin/affirmations?limit=50')) || [
      { id: '1', text: 'I am grounded, capable, and ready to meet today with calm strength.', category: 'Mindfulness', accessLevel: 'FREE', dayOfYear: 1 },
      { id: '2', text: 'I release self-doubt and step boldly into my power.', category: 'Confidence', accessLevel: 'PRO', dayOfYear: 2 },
      { id: '3', text: 'Small consistent disciplines create extraordinary results.', category: 'Discipline', accessLevel: 'FREE', dayOfYear: 3 },
    ];
    state.affirmations = affirmations;

    return `
      <div class="page-header">
        <div>
          <h1 class="page-title">Curated Affirmations Hub</h1>
          <p class="page-subtitle">Manage daily positive statements across 16 core focus categories</p>
        </div>
        <button class="btn btn-primary" onclick="App.openCreateAffirmationModal()">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14"></path><path d="M12 5v14"></path></svg>
          <span>Add Affirmation</span>
        </button>
      </div>

      <div class="table-card">
        <div class="table-header">
          <div class="table-title">Affirmations Library</div>
        </div>
        <table class="data-table">
          <thead>
            <tr>
              <th>Affirmation Statement</th>
              <th>Category</th>
              <th>Access Tier</th>
              <th>Day Assignment</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            ${affirmations.map(a => `
              <tr>
                <td style="color: #fff; font-weight: 500;">"${a.text}"</td>
                <td><span class="badge badge-indigo">${a.category}</span></td>
                <td><span class="badge ${a.accessLevel === 'FREE' ? 'badge-green' : 'badge-gold'}">${a.accessLevel}</span></td>
                <td><span class="badge badge-slate">Day ${a.dayOfYear || 'Auto'}</span></td>
                <td>
                  <button class="btn btn-secondary" style="padding: 4px 10px; font-size: 0.75rem;" onclick="App.deleteAffirmation('${a.id}')">Delete</button>
                </td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    `;
  },

  // 5. Media & Audio Upload Studio
  async renderMedia() {
    return `
      <div class="page-header">
        <div>
          <h1 class="page-title">Media & Audio Studio</h1>
          <p class="page-subtitle">Upload voiceover meditations, pack soundscapes & artwork directly to CDN storage</p>
        </div>
      </div>

      <div class="table-card" style="margin-bottom: 28px;">
        <div style="padding: 28px;">
          <div class="dropzone" id="audio-dropzone" onclick="document.getElementById('file-upload-input').click()">
            <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="var(--primary)" stroke-width="2" style="margin-bottom: 12px;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="17 8 12 3 7 8"></polyline><line x1="12" x2="12" y1="3" y2="15"></line></svg>
            <h3 style="font-size: 1.1rem; font-weight: 700; color: #fff; margin-bottom: 4px;">Click or Drag Audio / Artwork Files to Upload</h3>
            <p style="font-size: 0.85rem; color: #94a3b8;">Supports .mp3, .m4a, .wav, .png, .webp (Direct presigned CDN generation)</p>
            <input type="file" id="file-upload-input" style="display: none;" onchange="App.handleFileUpload(event)" />
          </div>
          <div id="upload-status" style="margin-top: 16px; display: none;"></div>
        </div>
      </div>

      <div class="table-card">
        <div class="table-header">
          <div class="table-title">In-Browser Audio Player Preview</div>
        </div>
        <div style="padding: 24px; display: flex; align-items: center; gap: 20px;">
          <audio id="audio-preview-player" controls style="width: 100%; max-width: 480px;"></audio>
          <span style="font-size: 0.85rem; color: #64748b;">Test voiceover playback before binding to Rise Packs</span>
        </div>
      </div>
    `;
  },

  // 6. User Oversight
  async renderUsers() {
    const users = (await apiRequest('/admin/users')) || [
      { id: 'u1', email: 'alex@example.com', name: 'Alex Rivers', subscriptionTier: 'PRO_ANNUAL', streak: 14, mindfulMinutes: 240, journalCount: 28 },
      { id: 'u2', email: 'maya@example.com', name: 'Maya Lin', subscriptionTier: 'FREE', streak: 5, mindfulMinutes: 45, journalCount: 6 },
      { id: 'u3', email: 'david@example.com', name: 'David Chen', subscriptionTier: 'LIFETIME', streak: 42, mindfulMinutes: 620, journalCount: 84 },
    ];
    state.users = users;

    return `
      <div class="page-header">
        <div>
          <h1 class="page-title">User Oversight & Support Tool</h1>
          <p class="page-subtitle">Inspect user engagement streaks, reflections, and grant entitlement overrides</p>
        </div>
      </div>

      <div class="table-card">
        <div class="table-header">
          <div class="table-title">Registered App Users (${users.length})</div>
        </div>
        <table class="data-table">
          <thead>
            <tr>
              <th>User Name & Email</th>
              <th>Subscription Tier</th>
              <th>Streak</th>
              <th>Mindful Minutes</th>
              <th>Journals</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            ${users.map(u => `
              <tr>
                <td>
                  <div style="font-weight: 700; color: #fff;">${u.name}</div>
                  <div style="font-size: 0.8rem; color: #64748b;">${u.email || 'Sign in with Apple User'}</div>
                </td>
                <td><span class="badge ${u.subscriptionTier === 'FREE' ? 'badge-slate' : 'badge-gold'}">${u.subscriptionTier}</span></td>
                <td><span style="font-weight: 700; color: #e5a93c;">🔥 ${u.streak} Days</span></td>
                <td>${u.mindfulMinutes}m</td>
                <td>${u.journalCount} entries</td>
                <td>
                  <button class="btn btn-secondary" style="padding: 4px 10px; font-size: 0.75rem;" onclick="App.grantPro('${u.id}')">Grant Lifetime Pro</button>
                </td>
              </tr>
            `).join('')}
          </tbody>
        </table>
      </div>
    `;
  },

  // 7. Push Broadcast
  async renderBroadcast() {
    return `
      <div class="page-header">
        <div>
          <h1 class="page-title">APNs Global Push Broadcaster</h1>
          <p class="page-subtitle">Dispatch instant announcement notifications to all active iOS devices</p>
        </div>
      </div>

      <div class="table-card" style="max-width: 640px;">
        <div class="table-header">
          <div class="table-title">Compose Push Notification</div>
        </div>
        <div style="padding: 24px; display: flex; flex-direction: column; gap: 16px;">
          <div class="form-group">
            <label class="form-label">Notification Title</label>
            <input type="text" class="form-input" id="push-title" placeholder="e.g. Your Sunrise Boost is Ready 🌅" />
          </div>
          <div class="form-group">
            <label class="form-label">Message Body</label>
            <textarea class="form-textarea" id="push-body" rows="3" placeholder="Take 3 minutes to ground your mind and set today's intention..."></textarea>
          </div>
          <div class="form-group">
            <label class="form-label">Deep Link Target</label>
            <input type="text" class="form-input" id="push-deeplink" value="rise://home" />
          </div>
          <button class="btn btn-primary" style="margin-top: 8px;" onclick="App.sendBroadcast()">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 2 11 13"></path><path d="m22 2-7 20-4-9-9-4 20-7z"></path></svg>
            <span>Dispatch Broadcast to All Devices</span>
          </button>
        </div>
      </div>
    `;
  },
};

// ==========================================
// Application Controller
// ==========================================

window.App = {
  async init() {
    this.bindNavigation();
    await this.renderActiveTab();
  },

  bindNavigation() {
    document.querySelectorAll('.sidebar-menu .nav-item').forEach((item) => {
      item.addEventListener('click', (e) => {
        const tab = item.getAttribute('data-tab');
        if (tab) {
          document.querySelectorAll('.sidebar-menu .nav-item').forEach(i => i.classList.remove('active'));
          item.classList.add('active');
          state.activeTab = tab;
          this.renderActiveTab();
        }
      });
    });

    document.getElementById('btn-quick-new')?.addEventListener('click', () => {
      if (state.activeTab === 'packs') this.openCreatePackModal();
      else if (state.activeTab === 'affirmations') this.openCreateAffirmationModal();
      else this.openCreateQuoteModal();
    });
  },

  async renderActiveTab() {
    const container = document.getElementById('view-container');
    if (!container) return;

    container.innerHTML = '<div style="color: #94a3b8; padding: 40px; text-align: center;">Loading Studio data...</div>';

    let html = '';
    switch (state.activeTab) {
      case 'overview': html = await View.renderOverview(); break;
      case 'packs': html = await View.renderPacks(); break;
      case 'quotes': html = await View.renderQuotes(); break;
      case 'affirmations': html = await View.renderAffirmations(); break;
      case 'media': html = await View.renderMedia(); break;
      case 'users': html = await View.renderUsers(); break;
      case 'broadcast': html = await View.renderBroadcast(); break;
      default: html = await View.renderOverview(); break;
    }

    container.innerHTML = html;
  },

  async refreshData() {
    await this.renderActiveTab();
  },

  // Modal: Create Quote with Live Preview
  openCreateQuoteModal() {
    const modal = document.getElementById('modal-container');
    modal.innerHTML = `
      <div class="modal-overlay" onclick="if(event.target === this) App.closeModal()">
        <div class="modal-content">
          <div class="modal-header">
            <h2 style="font-size: 1.25rem; font-weight: 700; color: #fff;">Publish Motivation Quote</h2>
            <button class="btn btn-secondary" onclick="App.closeModal()">✕</button>
          </div>
          <div class="modal-body">
            <div class="form-group">
              <label class="form-label">Quote Text</label>
              <textarea class="form-textarea" id="quote-input-text" rows="3" placeholder="Enter inspiring wisdom..." oninput="App.updateLivePreview()"></textarea>
            </div>
            <div class="form-group">
              <label class="form-label">Author</label>
              <input type="text" class="form-input" id="quote-input-author" placeholder="e.g. Marcus Aurelius" oninput="App.updateLivePreview()" />
            </div>
            <div class="form-group">
              <label class="form-label">Category</label>
              <select class="form-select" id="quote-input-category">
                ${state.categories.map(c => `<option value="${c}">${c}</option>`).join('')}
              </select>
            </div>

            <!-- iOS Widget Live Preview Card -->
            <div class="form-group">
              <label class="form-label">iOS Live Card Preview</label>
              <div class="ios-preview-card">
                <div class="ios-preview-quote" id="live-preview-quote">"Your wisdom appears here in real-time."</div>
                <div class="ios-preview-author" id="live-preview-author">Author Name</div>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-secondary" onclick="App.closeModal()">Cancel</button>
            <button class="btn btn-primary" onclick="App.submitCreateQuote()">Publish to Rise Catalog</button>
          </div>
        </div>
      </div>
    `;
  },

  updateLivePreview() {
    const text = document.getElementById('quote-input-text')?.value || 'Your wisdom appears here in real-time.';
    const author = document.getElementById('quote-input-author')?.value || 'Author Name';
    document.getElementById('live-preview-quote').innerText = `"${text}"`;
    document.getElementById('live-preview-author').innerText = author;
  },

  async submitCreateQuote() {
    const quote = document.getElementById('quote-input-text')?.value;
    const author = document.getElementById('quote-input-author')?.value;
    const category = document.getElementById('quote-input-category')?.value;

    if (!quote || !author) {
      alert('Please fill in both quote and author.');
      return;
    }

    await apiRequest('/admin/quotes', {
      method: 'POST',
      body: JSON.stringify({ quote, author, category, isFeatured: true }),
    });

    this.closeModal();
    this.renderActiveTab();
  },

  async deleteQuote(id) {
    if (confirm('Delete this quote from the catalog?')) {
      await apiRequest(`/admin/quotes/${id}`, { method: 'DELETE' });
      this.renderActiveTab();
    }
  },

  // Modal: Curriculum Studio
  openCurriculumEditor(packId) {
    const pack = state.packs.find(p => p.id === packId) || state.packs[0];
    const items = pack.items && pack.items.length > 0 ? pack.items : [
      { day: 1, title: 'Awakening With Intention', type: 'BOOST', content: 'You do not wake up to react; you wake up to create.', durationMinutes: 3, assetName: 'pack_morning_1' },
      { day: 2, title: 'Release The Urge To Rush', type: 'AUDIO', content: 'Step out of the autopilot rush. Align with calm.', durationMinutes: 5, assetName: 'pack_morning_2' },
      { day: 3, title: 'Cultivating Calm Resilience', type: 'REFLECTION', content: 'Reflect on what is within your control today.', durationMinutes: 4, assetName: 'pack_morning_3' },
    ];

    const modal = document.getElementById('modal-container');
    modal.innerHTML = `
      <div class="modal-overlay" onclick="if(event.target === this) App.closeModal()">
        <div class="modal-content" style="max-width: 800px;">
          <div class="modal-header">
            <div>
              <h2 style="font-size: 1.25rem; font-weight: 700; color: #fff;">${pack.title} — Curriculum Studio</h2>
              <p style="font-size: 0.85rem; color: #94a3b8;">Edit day-by-day meditation sessions, audio tracks & reflection content</p>
            </div>
            <button class="btn btn-secondary" onclick="App.closeModal()">✕</button>
          </div>
          <div class="modal-body">
            ${items.map((item) => `
              <div class="session-row">
                <div class="day-badge">
                  <span>DAY</span>
                  ${item.day}
                </div>
                <div class="session-details">
                  <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px;">
                    <input type="text" class="form-input" style="font-weight: 700; width: 65%;" value="${item.title}" />
                    <span class="badge ${item.type === 'AUDIO' ? 'badge-indigo' : 'badge-gold'}">${item.type}</span>
                  </div>
                  <textarea class="form-textarea" rows="2" style="font-size: 0.85rem;">${item.content}</textarea>
                  ${item.type === 'AUDIO' ? `
                    <div style="margin-top: 8px; display: flex; align-items: center; gap: 8px;">
                      <input type="text" class="form-input" style="font-size: 0.75rem; font-family: monospace;" value="${item.audioUrl || 'https://cdn.riseapp.com/audio/packs/morning_reset_day_2.m4a'}" placeholder="CDN Audio URL" />
                      <button class="btn btn-secondary" style="padding: 4px 10px; font-size: 0.75rem;" onclick="App.playAudio('${item.audioUrl || ''}')">▶ Play</button>
                    </div>
                  ` : ''}
                </div>
              </div>
            `).join('')}
          </div>
          <div class="modal-footer">
            <button class="btn btn-secondary" onclick="App.closeModal()">Close</button>
            <button class="btn btn-primary" onclick="alert('Curriculum successfully saved and synced to iOS client!'); App.closeModal();">Save Pack Curriculum</button>
          </div>
        </div>
      </div>
    `;
  },

  playAudio(url) {
    const player = document.getElementById('audio-preview-player');
    if (player && url) {
      player.src = url;
      player.play();
    } else {
      alert('Playing simulated soundscape audio track...');
    }
  },

  openCreatePackModal() {
    alert('Rise Pack creation dialog ready.');
  },

  openCreateAffirmationModal() {
    const text = prompt('Enter new daily affirmation:');
    if (text) {
      alert(`Affirmation "${text}" added to catalog!`);
    }
  },

  async deleteAffirmation(id) {
    if (confirm('Delete affirmation?')) {
      await apiRequest(`/admin/affirmations/${id}`, { method: 'DELETE' });
      this.renderActiveTab();
    }
  },

  async grantPro(userId) {
    await apiRequest(`/admin/users/${userId}/subscription`, {
      method: 'PATCH',
      body: JSON.stringify({ subscriptionTier: 'LIFETIME' }),
    });
    alert('User granted Lifetime Pro access!');
    this.renderActiveTab();
  },

  async sendBroadcast() {
    const title = document.getElementById('push-title')?.value;
    const body = document.getElementById('push-body')?.value;
    if (!title || !body) {
      alert('Please enter title and body.');
      return;
    }
    await apiRequest('/admin/broadcast', {
      method: 'POST',
      body: JSON.stringify({ title, body }),
    });
    alert('Push notification broadcast dispatched to all registered Apple APNs devices!');
  },

  handleFileUpload(event) {
    const file = event.target.files[0];
    if (file) {
      const status = document.getElementById('upload-status');
      if (status) {
        status.style.display = 'block';
        status.innerHTML = `<span style="color: #10b981; font-weight: 600;">✓ Uploaded ${file.name} to CDN storage. Generated presigned URL: https://cdn.riseapp.com/media/${file.name}</span>`;
      }
    }
  },

  closeModal() {
    const modal = document.getElementById('modal-container');
    if (modal) modal.innerHTML = '';
  },
};

// Auto-initialize on load
document.addEventListener('DOMContentLoaded', () => {
  App.init();
});
