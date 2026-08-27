//
//  RemoteConfig.tsx
//  RiseAdmin
//
//  Dynamic feature flags and client configuration without App Store review
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

export const RemoteConfig: React.FC = () => {
  const [flags, setFlags] = useState([
    { key: 'enable_ai_growth_reports', type: 'BOOLEAN', value: 'true', description: 'Enable personalized weekly growth insight cards' },
    { key: 'min_supported_ios_version', type: 'STRING', value: '1.0.0', description: 'Force update threshold build' },
    { key: 'paywall_hero_headline', type: 'STRING', value: 'Unlock 500+ Daily Meditations & Packs', description: 'A/B test paywall headline' },
    { key: 'show_streak_freeze_prompt', type: 'BOOLEAN', value: 'true', description: 'Prompt users on day 3 with a streak freeze shield' },
  ]);

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Remote Config & Feature Flags</h1>
          <p className="view-subtitle">Dynamic client flags synced to iOS app on launch without App Store rebuilds</p>
        </div>
        <button className="btn btn-primary btn-sm" onClick={() => alert('New feature flag added.')}>
          <Icons.Plus />
          <span>Add Flag</span>
        </button>
      </div>

      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">Active Flags & Variables ({flags.length})</span>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Flag Key</th>
              <th>Type</th>
              <th>Current Value</th>
              <th>Description</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {flags.map((f) => (
              <tr key={f.key}>
                <td style={{ fontFamily: 'monospace', fontWeight: 600, color: '#fff' }}>{f.key}</td>
                <td><span className="pill-badge pill-slate">{f.type}</span></td>
                <td>
                  <input
                    type="text"
                    className="flat-input"
                    defaultValue={f.value}
                    style={{ fontFamily: 'monospace', width: '160px' }}
                  />
                </td>
                <td style={{ fontSize: '12px' }}>{f.description}</td>
                <td>
                  <button className="btn btn-secondary btn-sm" onClick={() => alert(`Saved flag ${f.key}`)}>Save</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
