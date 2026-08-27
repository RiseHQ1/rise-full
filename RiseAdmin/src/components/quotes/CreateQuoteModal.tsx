//
//  CreateQuoteModal.tsx
//  RiseAdmin
//
//  Add quote modal with artwork selector and live iOS preview card
//

import React, { useState } from 'react';
import { ArtworkPicker } from '../common/ArtworkPicker.js';
import { RISE_CATEGORIES } from '../../config/constants.js';

interface CreateQuoteModalProps {
  onClose: () => void;
  onSubmit: (quote: { quote: string; author: string; category: string; assetName: string; dayOfYear?: number }) => void;
}

export const CreateQuoteModal: React.FC<CreateQuoteModalProps> = ({ onClose, onSubmit }) => {
  const [quote, setQuote] = useState('');
  const [author, setAuthor] = useState('');
  const [category, setCategory] = useState('Stoicism');
  const [assetName, setAssetName] = useState('onboarding_motivation_bg');
  const [dayOfYear, setDayOfYear] = useState<number | undefined>(undefined);

  const handleSubmit = () => {
    if (!quote || !author) {
      alert('Please fill in both quote text and author.');
      return;
    }
    onSubmit({ quote, author, category, assetName, dayOfYear });
  };

  return (
    <div className="modal-backdrop" onClick={(e) => { if (e.target === e.currentTarget) onClose(); }}>
      <div className="modal-window" style={{ maxWidth: '640px' }}>
        <div className="modal-head">
          <span style={{ fontWeight: 700, fontSize: '13.5px', color: '#fff' }}>Publish Motivation Quote</span>
          <button className="btn btn-secondary btn-sm" onClick={onClose}>✕</button>
        </div>
        <div className="modal-main">
          <div className="input-field">
            <label className="input-label">Quote Text</label>
            <textarea
              className="textarea-input"
              rows={3}
              placeholder="Enter wisdom statement..."
              value={quote}
              onChange={(e) => setQuote(e.target.value)}
            ></textarea>
          </div>

          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px' }}>
            <div className="input-field">
              <label className="input-label">Author / Attribution</label>
              <input
                type="text"
                className="text-input"
                placeholder="e.g. Marcus Aurelius"
                value={author}
                onChange={(e) => setAuthor(e.target.value)}
              />
            </div>
            <div className="input-field">
              <label className="input-label">Category</label>
              <select
                className="flat-select"
                value={category}
                onChange={(e) => setCategory(e.target.value)}
              >
                {RISE_CATEGORIES.map((c) => (
                  <option key={c} value={c}>{c}</option>
                ))}
              </select>
            </div>
          </div>

          <div className="input-field">
            <label className="input-label">Day of Year Rotation (Optional, 1-366)</label>
            <input
              type="number"
              min="1"
              max="366"
              className="text-input"
              placeholder="e.g. 238 (Leave blank for dynamic rotation)"
              value={dayOfYear || ''}
              onChange={(e) => setDayOfYear(e.target.value ? Number(e.target.value) : undefined)}
            />
          </div>

          {/* Artwork Image Picker & Uploader */}
          <ArtworkPicker
            label="Card Artwork / Background Texture"
            value={assetName}
            onChange={setAssetName}
          />

          {/* Clean Flat iOS Card Live Preview */}
          <div className="input-field">
            <label className="input-label">iOS Live Card Preview</label>
            <div
              style={{
                backgroundColor: '#161E31',
                border: '1px solid #1E2738',
                borderRadius: '6px',
                padding: '20px',
                position: 'relative',
                overflow: 'hidden',
                background: assetName.startsWith('http')
                  ? `linear-gradient(rgba(11, 15, 23, 0.85), rgba(11, 15, 23, 0.85)), url(${assetName}) center/cover no-repeat`
                  : '#161E31',
              }}
            >
              <div style={{ fontStyle: 'italic', fontSize: '14.5px', color: '#fff', marginBottom: '8px', lineHeight: 1.4 }}>
                "{quote || 'Your wisdom appears here in real-time.'}"
              </div>
              <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
                <div style={{ fontSize: '11.5px', fontWeight: 700, color: '#f59e0b', textTransform: 'uppercase' }}>
                  {author || 'Author Name'}
                </div>
                <span className="pill-badge pill-amber">{category}</span>
              </div>
            </div>
          </div>
        </div>

        <div className="modal-foot">
          <button className="btn btn-secondary btn-sm" onClick={onClose}>Cancel</button>
          <button className="btn btn-primary btn-sm" onClick={handleSubmit}>Publish to Catalog</button>
        </div>
      </div>
    </div>
  );
};
