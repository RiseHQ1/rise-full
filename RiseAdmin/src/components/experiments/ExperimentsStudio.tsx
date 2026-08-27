//
//  ExperimentsStudio.tsx
//  RiseAdmin
//
//  Paywall & Onboarding A/B Testing Experiments Studio
//

import React, { useState } from 'react';
import { Icons } from '../common/Icons.js';

export const ExperimentsStudio: React.FC = () => {
  const [experiments, setExperiments] = useState([
    {
      id: 'exp_01',
      name: 'Paywall Annual Discount Callout',
      key: 'paywall_annual_banner',
      status: 'RUNNING',
      traffic: '50% / 50%',
      variantA: { name: 'Control (Standard 7-Day Trial)', impressions: 420, conversions: 98, rate: '23.3%' },
      variantB: { name: 'Variant B ("Save 45% on Annual")', impressions: 412, conversions: 124, rate: '30.1%' },
      lift: '+29.2%',
      significance: '98.4% (Winner Likely)',
    },
    {
      id: 'exp_02',
      name: 'Onboarding Step Length',
      key: 'onboarding_length_v2',
      status: 'RUNNING',
      traffic: '50% / 50%',
      variantA: { name: '3-Step Quick Setup', impressions: 310, conversions: 278, rate: '89.6%' },
      variantB: { name: '5-Step Deep Personalization', impressions: 298, conversions: 242, rate: '81.2%' },
      lift: '-9.4%',
      significance: '95.1%',
    },
  ]);

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Paywall & A/B Experiments Studio</h1>
          <p className="view-subtitle">Live multivariate testing, conversion rate tracking, and statistical significance</p>
        </div>
        <button className="btn btn-primary btn-sm" onClick={() => alert('New A/B Experiment wizard ready.')}>
          <Icons.Plus />
          <span>New Experiment</span>
        </button>
      </div>

      <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
        {experiments.map((exp) => (
          <div key={exp.id} className="flat-card">
            <div className="flat-card-header">
              <div>
                <div style={{ display: 'flex', alignItems: 'center', gap: '8px' }}>
                  <span className="card-title">{exp.name}</span>
                  <span className="pill-badge pill-emerald">{exp.status}</span>
                </div>
                <div style={{ fontSize: '11px', fontFamily: 'monospace', color: '#64748b', marginTop: '2px' }}>
                  Key: {exp.key} · Split: {exp.traffic}
                </div>
              </div>
              <div style={{ textAlign: 'right' }}>
                <span className="pill-badge pill-amber">Confidence: {exp.significance}</span>
              </div>
            </div>

            <table className="flat-table">
              <thead>
                <tr>
                  <th>Variant</th>
                  <th>Impressions</th>
                  <th>Conversions</th>
                  <th>Conversion Rate</th>
                  <th>Observed Lift</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td style={{ fontWeight: 600, color: '#fff' }}>{exp.variantA.name}</td>
                  <td>{exp.variantA.impressions}</td>
                  <td>{exp.variantA.conversions}</td>
                  <td><span className="pill-badge pill-slate">{exp.variantA.rate}</span></td>
                  <td>Baseline</td>
                </tr>
                <tr>
                  <td style={{ fontWeight: 600, color: '#f59e0b' }}>{exp.variantB.name}</td>
                  <td>{exp.variantB.impressions}</td>
                  <td>{exp.variantB.conversions}</td>
                  <td><span className="pill-badge pill-emerald">{exp.variantB.rate}</span></td>
                  <td style={{ fontWeight: 700, color: '#10b981' }}>{exp.lift}</td>
                </tr>
              </tbody>
            </table>
          </div>
        ))}
      </div>
    </div>
  );
};
