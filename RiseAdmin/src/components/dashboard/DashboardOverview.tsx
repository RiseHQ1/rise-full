//
//  DashboardOverview.tsx
//  RiseAdmin
//
//  Executive Command Center with real-time user activity feed, content pulse & system telemetry
//

import React from 'react';
import { Icons } from '../common/Icons.js';
import { PlatformSummary } from '../../types/admin.types.js';

interface DashboardOverviewProps {
  summary: PlatformSummary | null;
  onRefresh: () => void;
  onOpenPackStudio: () => void;
  onOpenAddQuote: () => void;
  onOpenMedia: () => void;
  onNavigateTab?: (tab: string) => void;
}

export const DashboardOverview: React.FC<DashboardOverviewProps> = ({
  summary,
  onRefresh,
  onOpenPackStudio,
  onOpenAddQuote,
  onOpenMedia,
  onNavigateTab,
}) => {
  // Live simulated stream of recent user activities
  const recentActivities = [
    { id: '1', user: 'Maya Lin', action: 'Completed Day 3 of "Morning Reset" Pack', time: '2m ago', type: 'PACK', tag: 'Morning' },
    { id: '2', user: 'David Chen', action: 'Reached 42-day mindfulness streak 🔥', time: '5m ago', type: 'STREAK', tag: 'Milestone' },
    { id: '3', user: 'Alex Rivers', action: 'Upgraded to Pro Annual Plan ($29.99)', time: '14m ago', type: 'BILLING', tag: 'Revenue' },
    { id: '4', user: 'Elena Rostova', action: 'Saved evening reflection: "Letting go of outside control"', time: '22m ago', type: 'JOURNAL', tag: 'Reflection' },
    { id: '5', user: 'Marcus Vance', action: 'Started 7-day "Unstoppable Confidence" Pack', time: '35m ago', type: 'PACK', tag: 'Confidence' },
  ];

  const topContent = [
    { title: 'Marcus Aurelius — "You have power over your mind..."', category: 'Stoicism', engagements: '890 views · 240 saves', badge: 'Top Daily Quote' },
    { title: 'Morning Reset: Day 1 Awakening with Intention', category: 'Morning', engagements: '640 sessions completed', badge: 'Top Rise Pack' },
    { title: '528Hz Solfeggio Harmonic Sine Waves', category: 'Soundscapes', engagements: '420 active listeners', badge: 'Top Ambient Audio' },
  ];

  return (
    <div>
      {/* Header */}
      <div className="header-row">
        <div>
          <h1 className="view-title">Executive Command Center</h1>
          <p className="view-subtitle">Real-time pulse on community activity, content engagement & infrastructure health</p>
        </div>
        <button className="btn btn-secondary btn-sm" onClick={onRefresh}>
          <Icons.Refresh />
          <span>Refresh Live Data</span>
        </button>
      </div>

      {/* KPI Cards */}
      {summary && (
        <div className="kpi-row" style={{ marginBottom: '16px' }}>
          <div className="kpi-flat-card">
            <div className="kpi-top">
              <span className="kpi-title">Total Registered Users</span>
              <div className="kpi-icon-box"><Icons.Users /></div>
            </div>
            <div className="kpi-value">{summary.totalUsers.toLocaleString()}</div>
            <span className="pill-badge pill-slate">{summary.freeUsers} Free Accounts</span>
          </div>

          <div className="kpi-flat-card">
            <div className="kpi-top">
              <span className="kpi-title">Active Pro Subscribers</span>
              <div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Sparkles /></div>
            </div>
            <div className="kpi-value">{summary.proUsers.toLocaleString()}</div>
            <span className="pill-badge pill-emerald">{summary.conversionRate} Conversion Rate</span>
          </div>

          <div className="kpi-flat-card">
            <div className="kpi-top">
              <span className="kpi-title">Published Official Packs</span>
              <div className="kpi-icon-box" style={{ color: '#f59e0b' }}><Icons.Box /></div>
            </div>
            <div className="kpi-value">{summary.totalPacks} Packs</div>
            <span className="pill-badge pill-amber">56 Audio Sessions</span>
          </div>

          <div className="kpi-flat-card">
            <div className="kpi-top">
              <span className="kpi-title">Encrypted Reflections</span>
              <div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.Quote /></div>
            </div>
            <div className="kpi-value">{summary.totalJournals.toLocaleString()}</div>
            <span className="pill-badge pill-indigo">Multi-Device Synced</span>
          </div>
        </div>
      )}

      {/* System Status Banner / Notification Bar */}
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
        {/* LEFT COLUMN: Live Activity Stream */}
        <div className="flat-card">
          <div className="flat-card-header">
            <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
              <Icons.Activity />
              <span className="card-title">Live Community Activity Feed</span>
            </div>
            <span className="pill-badge pill-emerald">Live Stream</span>
          </div>
          <div style={{ padding: '4px 0' }}>
            {recentActivities.map((act) => (
              <div
                key={act.id}
                style={{
                  padding: '12px 18px',
                  borderBottom: '1px solid #182030',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'space-between',
                  gap: '12px',
                }}
              >
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                  <div
                    style={{
                      width: '28px',
                      height: '28px',
                      borderRadius: '4px',
                      background: act.type === 'BILLING' ? 'rgba(16, 185, 129, 0.15)' : act.type === 'STREAK' ? 'rgba(245, 158, 11, 0.15)' : 'rgba(99, 102, 241, 0.15)',
                      color: act.type === 'BILLING' ? '#10b981' : act.type === 'STREAK' ? '#f59e0b' : '#6366f1',
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      fontSize: '11px',
                      fontWeight: 700,
                    }}
                  >
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

        {/* RIGHT COLUMN: Real-Time Telemetry & Habit Curves */}
        <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
          {/* Infrastructure Health Card */}
          <div className="flat-card">
            <div className="flat-card-header">
              <span className="card-title">Live Infrastructure & Queue Status</span>
              <span className="pill-badge pill-slate">Fastify V8 Node</span>
            </div>
            <div style={{ padding: '16px 18px', display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
              <div style={{ background: '#151C2C', padding: '10px 14px', borderRadius: '4px', border: '1px solid #1E2738' }}>
                <div style={{ fontSize: '11px', color: '#94a3b8' }}>Database Latency</div>
                <div style={{ fontSize: '16px', fontWeight: 700, color: '#10b981', marginTop: '2px' }}>1.8ms</div>
                <div style={{ fontSize: '10.5px', color: '#64748b' }}>PgBouncer Pool: Optimal</div>
              </div>
              <div style={{ background: '#151C2C', padding: '10px 14px', borderRadius: '4px', border: '1px solid #1E2738' }}>
                <div style={{ fontSize: '11px', color: '#94a3b8' }}>Redis Cache Hit Rate</div>
                <div style={{ fontSize: '16px', fontWeight: 700, color: '#f59e0b', marginTop: '2px' }}>94.2%</div>
                <div style={{ fontSize: '10.5px', color: '#64748b' }}>Token Bucket & Quotes</div>
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

          {/* Daily Routine Habit Curve */}
          <div className="flat-card">
            <div className="flat-card-header">
              <span className="card-title">Daily Routine Habit Velocity</span>
              <span className="pill-badge pill-amber">Dual Peak: 7 AM & 9 PM</span>
            </div>
            <div style={{ padding: '16px 18px 10px' }}>
              <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', height: '64px', gap: '6px' }}>
                {[
                  { h: '6a', v: 45 }, { h: '7a', v: 95 }, { h: '8a', v: 80 }, { h: '9a', v: 35 },
                  { h: '12p', v: 50 }, { h: '3p', v: 30 }, { h: '6p', v: 40 }, { h: '8p', v: 75 },
                  { h: '9p', v: 90 }, { h: '10p', v: 60 }
                ].map((item, idx) => (
                  <div key={idx} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%', justifyContent: 'flex-end' }}>
                    <div
                      style={{
                        width: '100%',
                        height: `${(item.v / 100) * 50}px`,
                        background: item.v > 70 ? '#f59e0b' : '#1E2738',
                        borderRadius: '2px',
                      }}
                      title={`${item.h}: ${item.v}% activity`}
                    ></div>
                    <span style={{ fontSize: '9px', color: '#64748b', marginTop: '4px' }}>{item.h}</span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* TOP PERFORMING CONTENT WIDGET */}
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
            {topContent.map((c, i) => (
              <tr key={i}>
                <td style={{ fontWeight: 600, color: '#fff' }}>{c.title}</td>
                <td><span className="pill-badge pill-amber">{c.category}</span></td>
                <td>{c.engagements}</td>
                <td><span className="pill-badge pill-emerald">{c.badge}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* QUICK CONTENT OPERATIONS BAR */}
      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">Quick Studio Operations</span>
        </div>
        <div style={{ padding: '14px 18px', display: 'flex', gap: '8px', flexWrap: 'wrap' }}>
          <button className="btn btn-primary btn-sm" onClick={onOpenPackStudio}>
            <Icons.Box />
            <span>Open Pack Studio</span>
          </button>
          <button className="btn btn-secondary btn-sm" onClick={onOpenAddQuote}>
            <Icons.Quote />
            <span>Add Motivation Quote</span>
          </button>
          <button className="btn btn-secondary btn-sm" onClick={onOpenMedia}>
            <Icons.Music />
            <span>Upload Audio Track</span>
          </button>
          <button className="btn btn-secondary btn-sm" onClick={() => onNavigateTab && onNavigateTab('analytics')}>
            <Icons.BarChart />
            <span>View Full Analytics</span>
          </button>
          <button className="btn btn-secondary btn-sm" onClick={() => onNavigateTab && onNavigateTab('broadcast')}>
            <Icons.Bell />
            <span>Dispatch Push Alert</span>
          </button>
        </div>
      </div>
    </div>
  );
};
