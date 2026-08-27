//
//  BreathingCMS.tsx
//  RiseAdmin
//
//  Breathing Resets and Procedural Soundscape mapping configuration
//

import React from 'react';
import { Icons } from '../common/Icons.js';

export const BreathingCMS: React.FC = () => {
  const resets = [
    { id: 'box-breathing', title: 'Box Breathing (4-4-4-4)', subtitle: 'Settle tension & regain composure', durationMinutes: 3, pattern: '4s Inhale · 4s Hold · 4s Exhale · 4s Hold' },
    { id: 'deep-calm', title: '4-7-8 Deep Calm', subtitle: 'Calm the central nervous system', durationMinutes: 5, pattern: '4s Inhale · 7s Hold · 8s Exhale' },
    { id: 'morning-energize', title: 'Morning Energize', subtitle: 'Awaken your body & stimulate mental clarity', durationMinutes: 3, pattern: '5s Inhale · 2s Hold · 5s Exhale' },
  ];

  const soundscapes = [
    { id: 'zenBell', title: 'Zen Singing Bowl', type: 'Procedural Chime', freq: 'Harmonic 528Hz bell cues' },
    { id: 'binauralAlpha', title: 'Alpha Wave (8Hz)', type: 'Binaural Beat', freq: 'Calm focus & relaxation' },
    { id: 'pinkRain', title: 'Gentle Rain', type: 'Pink Noise DSP', freq: 'Warm soothing rainfall' },
    { id: 'brownHush', title: 'Deep Ocean Hush', type: 'Brown Noise DSP', freq: 'Deep ocean surf ambiance' },
    { id: 'solfeggio528', title: '528Hz Solfeggio', type: 'Pure Tone Sine', freq: 'Harmonic clarity frequency' },
    { id: 'forestDawn', title: 'Forest Dawn', type: 'Hybrid Nature Sound', freq: 'Fresh morning breeze & birds' },
  ];

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Breathing Resets & Soundscapes CMS</h1>
          <p className="view-subtitle">Paced breathwork patterns and on-device procedural audio presets</p>
        </div>
      </div>

      {/* Breathing Resets Table */}
      <div className="flat-card" style={{ marginBottom: '16px' }}>
        <div className="flat-card-header">
          <span className="card-title">Guided Breathing Resets</span>
          <button className="btn btn-primary btn-sm" onClick={() => alert('New breathing protocol wizard ready.')}>
            <Icons.Plus />
            <span>Add Protocol</span>
          </button>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Protocol Name</th>
              <th>Subtitle</th>
              <th>Timing Interval Pattern</th>
              <th>Duration</th>
            </tr>
          </thead>
          <tbody>
            {resets.map((r) => (
              <tr key={r.id}>
                <td style={{ fontWeight: 600, color: '#fff' }}>{r.title}</td>
                <td>{r.subtitle}</td>
                <td><span className="pill-badge pill-indigo">{r.pattern}</span></td>
                <td><span className="pill-badge pill-slate">{r.durationMinutes} Mins</span></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Soundscape Presets */}
      <div className="flat-card">
        <div className="flat-card-header">
          <span className="card-title">Procedural Ambient Soundscapes (AVAudioEngine Synthesizer)</span>
        </div>
        <table className="flat-table">
          <thead>
            <tr>
              <th>Soundscape Name</th>
              <th>Synthesis Engine Type</th>
              <th>Acoustic Frequency / Purpose</th>
            </tr>
          </thead>
          <tbody>
            {soundscapes.map((s) => (
              <tr key={s.id}>
                <td style={{ fontWeight: 600, color: '#fff' }}>{s.title}</td>
                <td><span className="pill-badge pill-amber">{s.type}</span></td>
                <td>{s.freq}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};
