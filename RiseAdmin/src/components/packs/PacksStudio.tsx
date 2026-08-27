//
//  PacksStudio.tsx
//  RiseAdmin
//
//  Rise Packs catalog grid with cover artwork thumbnails and StoreKit product management
//

import React, { useState, useMemo } from 'react';
import { Icons } from '../common/Icons.js';
import { AdminPack } from '../../types/admin.types.js';

interface PacksStudioProps {
  packs: AdminPack[];
  onSelectPack: (pack: AdminPack) => void;
  onCreatePack?: () => void;
}

export const PacksStudio: React.FC<PacksStudioProps> = ({ packs, onSelectPack, onCreatePack }) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [tierFilter, setTierFilter] = useState<'ALL' | 'FREE' | 'PRO'>('ALL');

  const filteredPacks = useMemo(() => {
    return packs.filter((p) => {
      const matchTier = tierFilter === 'ALL' || p.accessLevel === tierFilter;
      const matchSearch =
        !searchTerm ||
        p.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
        p.category.toLowerCase().includes(searchTerm.toLowerCase());
      return matchTier && matchSearch;
    });
  }, [packs, tierFilter, searchTerm]);

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Rise Packs Studio</h1>
          <p className="view-subtitle">Manage 7-day mini-experiences, cover artwork assets, StoreKit product IDs, and audio curricula</p>
        </div>
        {onCreatePack && (
          <button className="btn btn-primary btn-sm" onClick={onCreatePack}>
            <Icons.Plus />
            <span>Create New Pack</span>
          </button>
        )}
      </div>

      {/* Filter Bar */}
      <div className="flat-card" style={{ marginBottom: '16px' }}>
        <div className="flat-card-header">
          <div className="search-input-group" style={{ width: '100%', maxWidth: '280px' }}>
            <Icons.Search />
            <input
              type="text"
              placeholder="Search packs, categories..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
          </div>

          <div className="filter-row">
            <select
              className="flat-select"
              value={tierFilter}
              onChange={(e) => setTierFilter(e.target.value as any)}
            >
              <option value="ALL">All Access Tiers</option>
              <option value="FREE">Free Tier Only</option>
              <option value="PRO">Pro Subscribers Only</option>
            </select>
          </div>
        </div>
      </div>

      {/* Packs Grid */}
      <div className="pack-flat-grid">
        {filteredPacks.map((p) => (
          <div key={p.id} className="pack-flat-card">
            {/* Hero Artwork Cover Header */}
            <div
              style={{
                height: '110px',
                borderRadius: '4px',
                marginBottom: '12px',
                background: p.heroArtwork?.startsWith('http')
                  ? `linear-gradient(180deg, rgba(8, 12, 20, 0.2) 0%, rgba(8, 12, 20, 0.9) 100%), url(${p.heroArtwork}) center/cover no-repeat`
                  : 'linear-gradient(135deg, rgba(245, 158, 11, 0.2) 0%, rgba(15, 23, 42, 0.9) 100%)',
                border: '1px solid #1E2738',
                padding: '10px 12px',
                display: 'flex',
                flexDirection: 'column',
                justifyContent: 'space-between',
              }}
            >
              <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                <span className={`pill-badge ${p.accessLevel === 'FREE' ? 'pill-emerald' : 'pill-amber'}`}>
                  {p.accessLevel}
                </span>
                <span className="pill-badge pill-slate">{p.durationDays} Days</span>
              </div>
              <div style={{ fontSize: '10px', fontWeight: 700, textTransform: 'uppercase', color: '#f59e0b', letterSpacing: '0.05em' }}>
                {p.category}
              </div>
            </div>

            <div className="pack-flat-title">{p.title}</div>
            <div className="pack-flat-sub">{p.subtitle || 'Transformational daily routine and mindful habit builder.'}</div>

            <div style={{ fontSize: '11px', fontFamily: 'monospace', color: '#64748b', marginBottom: '10px' }}>
              <code>{p.storeKitProductId || 'Standard Free Access'}</code>
            </div>

            <div className="pack-flat-footer">
              <span style={{ fontWeight: 700, fontSize: '12px', color: '#fff' }}>{p.priceTier || 'Free'}</span>
              <button
                className="btn btn-secondary btn-sm"
                onClick={() => onSelectPack(p)}
              >
                Edit Curriculum ({p.items?.length || 7} Days)
              </button>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
