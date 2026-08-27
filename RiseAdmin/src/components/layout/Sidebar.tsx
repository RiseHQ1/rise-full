//
//  Sidebar.tsx
//  RiseAdmin
//
//  Clean, flat sidebar navigation with micro corner radius and all operational tabs
//

import React from 'react';
import { Icons } from '../common/Icons.js';

interface SidebarProps {
  activeTab: string;
  onSelectTab: (tab: string) => void;
  packCount: number;
}

export const Sidebar: React.FC<SidebarProps> = ({ activeTab, onSelectTab, packCount }) => {
  return (
    <aside className="sidebar">
      <div className="sidebar-header">
        <div className="brand-icon">R</div>
        <div className="brand-title">
          RISE <span className="brand-badge">Admin</span>
        </div>
      </div>

      <nav className="sidebar-nav">
        <div className="nav-section-label">Overview & Analytics</div>
        <button
          className={`nav-btn ${activeTab === 'overview' ? 'active' : ''}`}
          onClick={() => onSelectTab('overview')}
        >
          <Icons.Grid />
          <span>Dashboard</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'analytics' ? 'active' : ''}`}
          onClick={() => onSelectTab('analytics')}
        >
          <Icons.BarChart />
          <span>Product Analytics</span>
        </button>

        <div className="nav-section-label">Content CMS</div>
        <button
          className={`nav-btn ${activeTab === 'packs' ? 'active' : ''}`}
          onClick={() => onSelectTab('packs')}
        >
          <Icons.Box />
          <span>Rise Packs</span>
          <span className="nav-badge-pill">{packCount}</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'quotes' ? 'active' : ''}`}
          onClick={() => onSelectTab('quotes')}
        >
          <Icons.Quote />
          <span>Quotes & Thoughts</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'affirmations' ? 'active' : ''}`}
          onClick={() => onSelectTab('affirmations')}
        >
          <Icons.Sparkles />
          <span>Affirmations</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'breathing' ? 'active' : ''}`}
          onClick={() => onSelectTab('breathing')}
        >
          <Icons.Wind />
          <span>Breathing & Audio</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'media' ? 'active' : ''}`}
          onClick={() => onSelectTab('media')}
        >
          <Icons.Music />
          <span>Media & CDN Hub</span>
        </button>

        <div className="nav-section-label">Growth & Monetization</div>
        <button
          className={`nav-btn ${activeTab === 'ai' ? 'active' : ''}`}
          onClick={() => onSelectTab('ai')}
        >
          <Icons.Cpu />
          <span>AI Engine & Safety</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'monetization' ? 'active' : ''}`}
          onClick={() => onSelectTab('monetization')}
        >
          <Icons.CreditCard />
          <span>RevenueCat Ledger</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'experiments' ? 'active' : ''}`}
          onClick={() => onSelectTab('experiments')}
        >
          <Icons.Flask />
          <span>Paywall A/B Tests</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'campaigns' ? 'active' : ''}`}
          onClick={() => onSelectTab('campaigns')}
        >
          <Icons.Clock />
          <span>Lifecycle Drips</span>
        </button>

        <div className="nav-section-label">Support & Operations</div>
        <button
          className={`nav-btn ${activeTab === 'users' ? 'active' : ''}`}
          onClick={() => onSelectTab('users')}
        >
          <Icons.Users />
          <span>Users Directory</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'support' ? 'active' : ''}`}
          onClick={() => onSelectTab('support')}
        >
          <Icons.MessageSquare />
          <span>Feedback Desk</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'broadcast' ? 'active' : ''}`}
          onClick={() => onSelectTab('broadcast')}
        >
          <Icons.Bell />
          <span>APNs Broadcast</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'remoteconfig' ? 'active' : ''}`}
          onClick={() => onSelectTab('remoteconfig')}
        >
          <Icons.Sliders />
          <span>Remote Config</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'health' ? 'active' : ''}`}
          onClick={() => onSelectTab('health')}
        >
          <Icons.Activity />
          <span>System Health</span>
        </button>
        <button
          className={`nav-btn ${activeTab === 'audit' ? 'active' : ''}`}
          onClick={() => onSelectTab('audit')}
        >
          <Icons.Shield />
          <span>Security Audit</span>
        </button>
      </nav>

      <div className="sidebar-footer">
        <div className="admin-profile">
          <div className="admin-avatar">AD</div>
          <div>
            <div className="admin-name">Administrator</div>
            <div className="admin-role">Super Admin</div>
          </div>
        </div>
      </div>
    </aside>
  );
};
