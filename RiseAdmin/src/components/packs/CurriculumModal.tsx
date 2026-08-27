//
//  CurriculumModal.tsx
//  RiseAdmin
//
//  Day-by-day session curriculum builder modal with artwork picker and audio uploader
//

import React, { useState } from 'react';
import { ArtworkPicker } from '../common/ArtworkPicker.js';
import { AdminPack } from '../../types/admin.types.js';

interface CurriculumModalProps {
  pack: AdminPack;
  onClose: () => void;
  onSave: () => void;
}

export const CurriculumModal: React.FC<CurriculumModalProps> = ({ pack, onClose, onSave }) => {
  const [heroArtwork, setHeroArtwork] = useState(pack.heroArtwork || 'pack_morning_reset');
  const [storeKitId, setStoreKitId] = useState(pack.storeKitProductId || '');
  const [priceTier, setPriceTier] = useState(pack.priceTier || 'Free');

  const [items, setItems] = useState(
    pack.items && pack.items.length > 0
      ? pack.items
      : [
          { day: 1, title: 'Awakening With Intention', type: 'BOOST' as const, content: 'You do not wake up to react; you wake up to create.', durationMinutes: 3, assetName: 'pack_morning_1' },
          { day: 2, title: 'Release The Urge To Rush', type: 'AUDIO' as const, content: 'Step out of the autopilot rush and claim stillness.', durationMinutes: 5, assetName: 'pack_morning_2', audioUrl: 'https://cdn.riseapp.com/audio/packs/morning_reset_day_2.m4a' },
          { day: 3, title: 'Grounding Resilience', type: 'REFLECTION' as const, content: 'Reflect on what is within your control today.', durationMinutes: 4, assetName: 'pack_morning_3' },
        ]
  );

  return (
    <div className="modal-backdrop" onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <div className="modal-window" style={{ maxWidth: '780px' }}>
        <div className="modal-head">
          <div>
            <div style={{ fontWeight: 700, fontSize: '14px', color: '#fff' }}>{pack.title} — Curriculum Studio</div>
            <div style={{ fontSize: '11.5px', color: '#64748b' }}>Configure cover artwork, StoreKit product IDs, and day-by-day audio sessions</div>
          </div>
          <button className="btn btn-secondary btn-sm" onClick={onClose}>✕</button>
        </div>

        <div className="modal-main">
          {/* Pack Metadata & Artwork */}
          <div style={{ background: '#151C2C', padding: '16px', borderRadius: '4px', border: '1px solid #1E2738', display: 'flex', flexDirection: 'column', gap: '12px' }}>
            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
              <div className="input-field">
                <label className="input-label">StoreKit In-App Purchase ID</label>
                <input
                  type="text"
                  className="text-input"
                  placeholder="e.g. com.riseapp.pack.confidence"
                  value={storeKitId}
                  onChange={(e) => setStoreKitId(e.target.value)}
                />
              </div>
              <div className="input-field">
                <label className="input-label">Price Tier</label>
                <input
                  type="text"
                  className="text-input"
                  placeholder="e.g. $2.99 or Free"
                  value={priceTier}
                  onChange={(e) => setPriceTier(e.target.value)}
                />
              </div>
            </div>

            <ArtworkPicker
              label="Pack Cover Artwork Asset / CDN URL"
              value={heroArtwork}
              onChange={setHeroArtwork}
            />
          </div>

          {/* Day-by-Day Sessions List */}
          <div style={{ marginTop: '8px' }}>
            <div style={{ fontSize: '12.5px', fontWeight: 700, color: '#fff', marginBottom: '8px' }}>
              Day-by-Day Curriculum Sessions ({items.length} Days)
            </div>

            {items.map((item, idx) => (
              <div key={idx} className="session-item" style={{ flexDirection: 'column', alignItems: 'stretch' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '10px', marginBottom: '8px' }}>
                  <div className="session-day">D{item.day}</div>
                  <input
                    type="text"
                    className="text-input"
                    style={{ flex: 1, fontWeight: 600 }}
                    value={item.title}
                    onChange={(e) => {
                      const updated = [...items];
                      updated[idx].title = e.target.value;
                      setItems(updated);
                    }}
                  />
                  <select
                    className="flat-select"
                    value={item.type}
                    onChange={(e) => {
                      const updated = [...items];
                      updated[idx].type = e.target.value as any;
                      setItems(updated);
                    }}
                  >
                    <option value="BOOST">BOOST (Morning Prompt)</option>
                    <option value="AUDIO">AUDIO (Voiceover Track)</option>
                    <option value="REFLECTION">REFLECTION (Journal)</option>
                    <option value="BREATHE">BREATHE (Paced Exercise)</option>
                  </select>
                </div>

                <textarea
                  className="textarea-input"
                  rows={2}
                  style={{ fontSize: '12px', marginBottom: '6px' }}
                  value={item.content}
                  onChange={(e) => {
                    const updated = [...items];
                    updated[idx].content = e.target.value;
                    setItems(updated);
                  }}
                ></textarea>

                {/* Artwork & Audio link per session */}
                <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '8px', fontSize: '11px' }}>
                  <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                    <span style={{ color: '#64748b' }}>Artwork:</span>
                    <input
                      type="text"
                      className="text-input"
                      style={{ fontSize: '11px', fontFamily: 'monospace', padding: '4px 6px' }}
                      value={item.assetName || ''}
                      onChange={(e) => {
                        const updated = [...items];
                        updated[idx].assetName = e.target.value;
                        setItems(updated);
                      }}
                      placeholder="e.g. pack_morning_1"
                    />
                  </div>

                  {item.type === 'AUDIO' && (
                    <div style={{ display: 'flex', alignItems: 'center', gap: '6px' }}>
                      <span style={{ color: '#64748b' }}>Audio URL:</span>
                      <input
                        type="text"
                        className="text-input"
                        style={{ fontSize: '11px', fontFamily: 'monospace', padding: '4px 6px', flex: 1 }}
                        value={item.audioUrl || ''}
                        onChange={(e) => {
                          const updated = [...items];
                          updated[idx].audioUrl = e.target.value;
                          setItems(updated);
                        }}
                        placeholder="https://cdn.riseapp.com/audio/..."
                      />
                      <button
                        type="button"
                        className="btn btn-secondary btn-sm"
                        style={{ padding: '3px 8px' }}
                        onClick={() => alert(`Playing audio: ${item.audioUrl}`)}
                      >
                        ▶ Play
                      </button>
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="modal-foot">
          <button className="btn btn-secondary btn-sm" onClick={onClose}>Close</button>
          <button className="btn btn-primary btn-sm" onClick={onSave}>Save Curriculum & Artwork</button>
        </div>
      </div>
    </div>
  );
};
