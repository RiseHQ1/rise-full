//
//  AnalyticsStudio.tsx
//  RiseAdmin
//
//  Advanced visual analytics with SVG line charts, conversion funnels, donut breakdown & retention cohorts
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

export const AnalyticsStudio: React.FC = () => {
  const [timeRange, setTimeRange] = useState<'7d' | '30d' | '90d'>('30d');
  const [hoveredPoint, setHoveredPoint] = useState<{ day: string; dau: number; mau: number } | null>(null);

  // 30-Day Trend Data
  const trendData = [
    { day: 'Day 1', dau: 310, mau: 980 },
    { day: 'Day 5', dau: 345, mau: 1040 },
    { day: 'Day 10', dau: 380, mau: 1120 },
    { day: 'Day 15', dau: 395, mau: 1190 },
    { day: 'Day 20', dau: 420, mau: 1280 },
    { day: 'Day 25', dau: 442, mau: 1350 },
    { day: 'Day 30', dau: 460, mau: 1420 },
  ];

  // Weekly Growth Data (Free vs Pro)
  const weeklyData = [
    { week: 'W1', free: 210, pro: 48 },
    { week: 'W2', free: 245, pro: 62 },
    { week: 'W3', free: 280, pro: 75 },
    { week: 'W4', free: 320, pro: 92 },
    { week: 'W5', free: 350, pro: 114 },
    { week: 'W6', free: 390, pro: 138 },
    { week: 'W7', free: 420, pro: 156 },
    { week: 'W8', free: 460, pro: 180 },
  ];

  const cohorts = [
    { cohort: 'Aug 18 - Aug 24', users: 480, d1: '68%', d3: '52%', d7: '41%', d14: '34%', d30: '28%' },
    { cohort: 'Aug 11 - Aug 17', users: 512, d1: '66%', d3: '49%', d7: '39%', d14: '32%', d30: '26%' },
    { cohort: 'Aug 04 - Aug 10', users: 440, d1: '71%', d3: '54%', d7: '44%', d14: '36%', d30: '31%' },
    { cohort: 'Jul 28 - Aug 03', users: 390, d1: '64%', d3: '48%', d7: '38%', d14: '30%', d30: '25%' },
  ];

  const funnels = [
    { step: '1. App Install & Open', count: 1420, rate: '100%', width: '100%' },
    { step: '2. Focus Areas Selected', count: 1280, rate: '90.1%', width: '90.1%' },
    { step: '3. Routine Time Window Set', count: 1140, rate: '80.2%', width: '80.2%' },
    { step: '4. Paywall View', count: 980, rate: '69.0%', width: '69.0%' },
    { step: '5. Free Trial / Sub Started', count: 348, rate: '24.5%', width: '24.5%' },
  ];

  const hourlyActivity = [
    { hour: '5 AM', val: 12 }, { hour: '6 AM', val: 68 }, { hour: '7 AM', val: 95 },
    { hour: '8 AM', val: 84 }, { hour: '9 AM', val: 42 }, { hour: '12 PM', val: 56 },
    { hour: '3 PM', val: 38 }, { hour: '6 PM', val: 45 }, { hour: '8 PM', val: 78 },
    { hour: '9 PM', val: 92 }, { hour: '10 PM', val: 64 }, { hour: '11 PM', val: 24 }
  ];

  return (
    <div>
      {/* Header & Date Range Filter */}
      <div className="header-row">
        <div>
          <h1 className="view-title">Product & User Behavior Analytics</h1>
          <p className="view-subtitle">Interactive visual charts, retention cohort heatmaps, and funnel telemetry</p>
        </div>
        <div className="filter-row">
          <button
            className={`btn btn-sm ${timeRange === '7d' ? 'btn-primary' : 'btn-secondary'}`}
            onClick={() => setTimeRange('7d')}
          >
            7 Days
          </button>
          <button
            className={`btn btn-sm ${timeRange === '30d' ? 'btn-primary' : 'btn-secondary'}`}
            onClick={() => setTimeRange('30d')}
          >
            30 Days
          </button>
          <button
            className={`btn btn-sm ${timeRange === '90d' ? 'btn-primary' : 'btn-secondary'}`}
            onClick={() => setTimeRange('90d')}
          >
            90 Days
          </button>
        </div>
      </div>

      {/* KPI Stat Cards */}
      <div className="kpi-row" style={{ marginBottom: '16px' }}>
        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Daily Active Users (DAU)</span>
            <div className="kpi-icon-box" style={{ color: '#f59e0b' }}><Icons.Users /></div>
          </div>
          <div className="kpi-value">460</div>
          <span className="pill-badge pill-amber">+14.2% MoM Growth</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Monthly Active (MAU)</span>
            <div className="kpi-icon-box" style={{ color: '#6366f1' }}><Icons.BarChart /></div>
          </div>
          <div className="kpi-value">1,420</div>
          <span className="pill-badge pill-indigo">30-Day Window</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Stickiness (DAU/MAU)</span>
            <div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Sparkles /></div>
          </div>
          <div className="kpi-value">32.4%</div>
          <span className="pill-badge pill-emerald">Top Quartile Wellness</span>
        </div>

        <div className="kpi-flat-card">
          <div className="kpi-top">
            <span className="kpi-title">Avg Session Length</span>
            <div className="kpi-icon-box" style={{ color: '#10b981' }}><Icons.Clock /></div>
          </div>
          <div className="kpi-value">4m 18s</div>
          <span className="pill-badge pill-slate">Morning Boost + Journal</span>
        </div>
      </div>

      {/* 1. Interactive SVG Area/Line Chart: DAU & MAU Growth */}
      <div className="flat-card" style={{ marginBottom: '16px' }}>
        <div className="flat-card-header">
          <div>
            <span className="card-title">Daily Active Users Trend & Trajectory</span>
            <div style={{ fontSize: '11.5px', color: '#64748b', marginTop: '2px' }}>Hover over data points to inspect active user count</div>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: '12px' }}>
            <span style={{ fontSize: '12px', display: 'flex', alignItems: 'center', gap: '6px', color: '#f59e0b' }}>
              <span style={{ width: '8px', height: '8px', background: '#f59e0b', borderRadius: '1px' }}></span> DAU Trend
            </span>
            <span style={{ fontSize: '12px', display: 'flex', alignItems: 'center', gap: '6px', color: '#6366f1' }}>
              <span style={{ width: '8px', height: '8px', background: '#6366f1', borderRadius: '1px' }}></span> MAU Benchmark
            </span>
          </div>
        </div>

        <div style={{ padding: '20px 24px 10px' }}>
          <div style={{ position: 'relative', width: '100%', height: '220px' }}>
            <svg width="100%" height="200" viewBox="0 0 700 200" preserveAspectRatio="none" style={{ overflow: 'visible' }}>
              {/* Horizontal Grid lines */}
              <line x1="0" y1="40" x2="700" y2="40" stroke="#1E2738" strokeDasharray="3 3" />
              <line x1="0" y1="90" x2="700" y2="90" stroke="#1E2738" strokeDasharray="3 3" />
              <line x1="0" y1="140" x2="700" y2="140" stroke="#1E2738" strokeDasharray="3 3" />
              <line x1="0" y1="190" x2="700" y2="190" stroke="#1E2738" />

              {/* Area Fill */}
              <polygon
                points="0,190 0,160 116,145 233,130 350,120 466,105 583,92 700,80 700,190"
                fill="rgba(245, 158, 11, 0.08)"
              />

              {/* MAU Line */}
              <polyline
                points="0,60 116,54 233,48 350,42 466,35 583,28 700,20"
                fill="none"
                stroke="#6366f1"
                strokeWidth="2"
              />

              {/* DAU Line */}
              <polyline
                points="0,160 116,145 233,130 350,120 466,105 583,92 700,80"
                fill="none"
                stroke="#f59e0b"
                strokeWidth="2.5"
              />

              {/* Interactive Points */}
              {[
                { x: 0, y: 160, data: trendData[0] },
                { x: 116, y: 145, data: trendData[1] },
                { x: 233, y: 130, data: trendData[2] },
                { x: 350, y: 120, data: trendData[3] },
                { x: 466, y: 105, data: trendData[4] },
                { x: 583, y: 92, data: trendData[5] },
                { x: 700, y: 80, data: trendData[6] },
              ].map((pt, idx) => (
                <circle
                  key={idx}
                  cx={pt.x}
                  cy={pt.y}
                  r="4"
                  fill="#080C14"
                  stroke="#f59e0b"
                  strokeWidth="2.5"
                  style={{ cursor: 'pointer' }}
                  onMouseEnter={() => setHoveredPoint(pt.data)}
                  onMouseLeave={() => setHoveredPoint(null)}
                />
              ))}
            </svg>

            {/* Hover Tooltip */}
            {hoveredPoint && (
              <div
                style={{
                  position: 'absolute',
                  top: '10px',
                  right: '20px',
                  background: '#151C2C',
                  border: '1px solid #1E2738',
                  borderRadius: '4px',
                  padding: '6px 12px',
                  fontSize: '12px',
                  color: '#fff',
                }}
              >
                <div style={{ fontWeight: 700, color: '#f59e0b' }}>{hoveredPoint.day}</div>
                <div>DAU: <strong>{hoveredPoint.dau}</strong> · MAU: <strong>{hoveredPoint.mau}</strong></div>
              </div>
            )}
          </div>

          <div style={{ display: 'flex', justifyContent: 'space-between', marginTop: '12px', fontSize: '11px', color: '#64748b' }}>
            <span>Day 1</span>
            <span>Day 5</span>
            <span>Day 10</span>
            <span>Day 15</span>
            <span>Day 20</span>
            <span>Day 25</span>
            <span>Day 30</span>
          </div>
        </div>
      </div>

      {/* 2. Grid: Stacked Weekly Growth Bar Chart & Feature Distribution Donut */}
      <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(340px, 1fr))', gap: '16px', marginBottom: '16px' }}>
        {/* Stacked Bars: Free vs Pro Weekly Growth */}
        <div className="flat-card">
          <div className="flat-card-header">
            <span className="card-title">Weekly Free vs Pro Acquisition</span>
            <div style={{ display: 'flex', gap: '8px', fontSize: '11px' }}>
              <span style={{ color: '#10b981' }}>■ Pro Sub</span>
              <span style={{ color: '#64748b' }}>■ Free User</span>
            </div>
          </div>
          <div style={{ padding: '20px 20px 10px' }}>
            <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', height: '160px', gap: '8px' }}>
              {weeklyData.map((item, i) => {
                const totalH = ((item.free + item.pro) / 650) * 100;
                const proH = (item.pro / (item.free + item.pro)) * totalH;
                const freeH = totalH - proH;
                return (
                  <div key={i} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%', justifyContent: 'flex-end' }}>
                    <div style={{ width: '100%', maxWidth: '24px', display: 'flex', flexDirection: 'column', borderRadius: '3px', overflow: 'hidden' }}>
                      <div style={{ height: `${proH * 1.5}px`, background: '#10b981' }} title={`Pro: ${item.pro}`}></div>
                      <div style={{ height: `${freeH * 1.5}px`, background: '#1E2738' }} title={`Free: ${item.free}`}></div>
                    </div>
                    <span style={{ fontSize: '10.5px', color: '#64748b', marginTop: '6px' }}>{item.week}</span>
                  </div>
                );
              })}
            </div>
          </div>
        </div>

        {/* Feature Time Breakdown Ring / Donut */}
        <div className="flat-card">
          <div className="flat-card-header">
            <span className="card-title">Feature Time Allocation</span>
          </div>
          <div style={{ padding: '20px', display: 'flex', alignItems: 'center', justifyContent: 'space-around', flexWrap: 'wrap', gap: '16px' }}>
            {/* SVG Donut */}
            <div style={{ position: 'relative', width: '130px', height: '130px' }}>
              <svg width="130" height="130" viewBox="0 0 42 42">
                <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#151C2C" strokeWidth="6"></circle>
                {/* Morning Boost: 42% */}
                <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#f59e0b" strokeWidth="6" strokeDasharray="42 58" strokeDashoffset="25"></circle>
                {/* Journal Reflection: 28% */}
                <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#6366f1" strokeWidth="6" strokeDasharray="28 72" strokeDashoffset="83"></circle>
                {/* Breathing: 18% */}
                <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#10b981" strokeWidth="6" strokeDasharray="18 82" strokeDashoffset="55"></circle>
                {/* Packs: 12% */}
                <circle cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="#0ea5e9" strokeWidth="6" strokeDasharray="12 88" strokeDashoffset="37"></circle>
              </svg>
              <div style={{ position: 'absolute', inset: 0, display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center' }}>
                <span style={{ fontSize: '14px', fontWeight: 800, color: '#fff' }}>100%</span>
                <span style={{ fontSize: '9px', color: '#64748b', textTransform: 'uppercase' }}>Time Spent</span>
              </div>
            </div>

            {/* Legend */}
            <div style={{ display: 'flex', flexDirection: 'column', gap: '8px', fontSize: '11.5px' }}>
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ width: '8px', height: '8px', background: '#f59e0b', borderRadius: '1px' }}></span>
                <span style={{ color: '#fff', fontWeight: 600 }}>42%</span>
                <span style={{ color: '#94a3b8' }}>Morning Boost</span>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ width: '8px', height: '8px', background: '#6366f1', borderRadius: '1px' }}></span>
                <span style={{ color: '#fff', fontWeight: 600 }}>28%</span>
                <span style={{ color: '#94a3b8' }}>Reflections</span>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ width: '8px', height: '8px', background: '#10b981', borderRadius: '1px' }}></span>
                <span style={{ color: '#fff', fontWeight: 600 }}>18%</span>
                <span style={{ color: '#94a3b8' }}>Breathing</span>
              </div>
              <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                <span style={{ width: '8px', height: '8px', background: '#0ea5e9', borderRadius: '1px' }}></span>
                <span style={{ color: '#fff', fontWeight: 600 }}>12%</span>
                <span style={{ color: '#94a3b8' }}>Rise Packs</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* 3. 24-Hour Routine Bell Curve Activity */}
      <div className="flat-card" style={{ marginBottom: '16px' }}>
        <div className="flat-card-header">
          <span className="card-title">Hourly App Engagement Routine (Peak Habits)</span>
          <span className="pill-badge pill-amber">Dual Peak: 7 AM Sunrise & 9 PM Wind-Down</span>
        </div>
        <div style={{ padding: '20px 24px 14px' }}>
          <div style={{ display: 'flex', alignItems: 'flex-end', justifyContent: 'space-between', height: '110px', gap: '8px' }}>
            {hourlyActivity.map((h, idx) => (
              <div key={idx} style={{ flex: 1, display: 'flex', flexDirection: 'column', alignItems: 'center', height: '100%', justifyContent: 'flex-end' }}>
                <div
                  style={{
                    width: '100%',
                    height: `${(h.val / 100) * 85}px`,
                    background: h.val > 70 ? 'rgba(245, 158, 11, 0.85)' : '#1E2738',
                    borderRadius: '2px',
                  }}
                  title={`${h.hour}: ${h.val}% activity volume`}
                ></div>
                <span style={{ fontSize: '10px', color: '#64748b', marginTop: '6px', whiteSpace: 'nowrap' }}>{h.hour}</span>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* 4. Retention Cohorts Heatmap */}
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
            {cohorts.map((c, i) => (
              <tr key={i}>
                <td style={{ fontWeight: 600, color: '#fff' }}>{c.cohort}</td>
                <td>{c.users}</td>
                <td><span className="pill-badge pill-emerald">{c.d1}</span></td>
                <td><span className="pill-badge pill-emerald">{c.d3}</span></td>
                <td><span className="pill-badge pill-amber">{c.d7}</span></td>
                <td><span className="pill-badge pill-amber">{c.d14}</span></td>
                <td><span className="pill-badge pill-slate">{c.d30}</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* 5. Onboarding Visual Funnel Progress Bars */}
      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">Onboarding & Paywall Conversion Funnel</span>
        </div>
        <div style={{ padding: '16px 20px', display: 'flex', flexDirection: 'column', gap: '12px' }}>
          {funnels.map((f, i) => (
            <div key={i}>
              <div style={{ display: 'flex', justifyContent: 'space-between', fontSize: '12px', marginBottom: '4px' }}>
                <span style={{ color: '#fff', fontWeight: 500 }}>{f.step}</span>
                <span style={{ fontWeight: 700, color: i === 4 ? '#10b981' : '#94a3b8' }}>
                  {f.count.toLocaleString()} users ({f.rate})
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
  );
};
