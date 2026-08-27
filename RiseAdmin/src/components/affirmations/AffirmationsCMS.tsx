//
//  AffirmationsCMS.tsx
//  RiseAdmin
//
//  Affirmations Hub management table with search, category filtering, access tier filter, and pagination
//

import React, { useState, useMemo } from 'react';
import { Icons } from '../common/Icons.js';
import { Pagination } from '../common/Pagination.js';
import { AdminAffirmation } from '../../types/admin.types.js';
import { RISE_CATEGORIES } from '../../config/constants.js';

interface AffirmationsCMSProps {
  affirmations: AdminAffirmation[];
  filter: string;
  onFilterChange: (category: string) => void;
  onAddAffirmation: () => void;
}

export const AffirmationsCMS: React.FC<AffirmationsCMSProps> = ({
  affirmations,
  filter,
  onFilterChange,
  onAddAffirmation,
}) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [tierFilter, setTierFilter] = useState<'ALL' | 'FREE' | 'PRO'>('ALL');
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  const filtered = useMemo(() => {
    return affirmations.filter((a) => {
      const matchCategory = !filter || a.category.toLowerCase() === filter.toLowerCase();
      const matchTier = tierFilter === 'ALL' || a.accessLevel === tierFilter;
      const matchSearch = !searchTerm || a.text.toLowerCase().includes(searchTerm.toLowerCase());
      return matchCategory && matchTier && matchSearch;
    });
  }, [affirmations, filter, tierFilter, searchTerm]);

  const paginatedAffirmations = useMemo(() => {
    const start = (currentPage - 1) * pageSize;
    return filtered.slice(start, start + pageSize);
  }, [filtered, currentPage, pageSize]);

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Affirmations Hub</h1>
          <p className="view-subtitle">Curate 16-category daily affirmations, artwork assets, and access tiers for positive mindset</p>
        </div>
        <button className="btn btn-primary btn-sm" onClick={onAddAffirmation}>
          <Icons.Plus />
          <span>Add Affirmation</span>
        </button>
      </div>

      <div className="flat-card">
        {/* Search & Filter Bar */}
        <div className="flat-card-header">
          <div className="search-input-group" style={{ width: '100%', maxWidth: '280px' }}>
            <Icons.Search />
            <input
              type="text"
              placeholder="Search affirmations..."
              value={searchTerm}
              onChange={(e) => {
                setSearchTerm(e.target.value);
                setCurrentPage(1);
              }}
            />
          </div>

          <div className="filter-row" style={{ flexWrap: 'wrap', gap: '8px' }}>
            <select
              className="flat-select"
              value={filter}
              onChange={(e) => {
                onFilterChange(e.target.value);
                setCurrentPage(1);
              }}
            >
              <option value="">All Categories</option>
              {RISE_CATEGORIES.map((c) => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>

            <select
              className="flat-select"
              value={tierFilter}
              onChange={(e) => {
                setTierFilter(e.target.value as any);
                setCurrentPage(1);
              }}
            >
              <option value="ALL">All Access Tiers</option>
              <option value="FREE">Free Tier</option>
              <option value="PRO">Pro Tier</option>
            </select>
          </div>
        </div>

        {/* Table */}
        <table className="flat-table">
          <thead>
            <tr>
              <th>Affirmation Statement</th>
              <th>Category</th>
              <th>Access</th>
              <th>Day Assignment</th>
              <th>Artwork Asset</th>
            </tr>
          </thead>
          <tbody>
            {paginatedAffirmations.length === 0 ? (
              <tr>
                <td colSpan={5} style={{ textAlign: 'center', padding: '32px', color: '#64748b' }}>
                  No affirmations found matching filters.
                </td>
              </tr>
            ) : (
              paginatedAffirmations.map((a) => (
                <tr key={a.id}>
                  <td style={{ color: '#fff', fontWeight: 500 }}>"{a.text}"</td>
                  <td><span className="pill-badge pill-indigo">{a.category}</span></td>
                  <td>
                    <span className={`pill-badge ${a.accessLevel === 'FREE' ? 'pill-emerald' : 'pill-amber'}`}>
                      {a.accessLevel}
                    </span>
                  </td>
                  <td><span className="pill-badge pill-slate">Day {a.dayOfYear || 'Auto'}</span></td>
                  <td>
                    <span style={{ fontSize: '11px', fontFamily: 'monospace', color: '#64748b' }}>
                      {a.assetName || 'onboarding_motivation_bg'}
                    </span>
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>

        {/* Pagination Controls */}
        <Pagination
          currentPage={currentPage}
          totalItems={filtered.length}
          pageSize={pageSize}
          onPageChange={setCurrentPage}
          onPageSizeChange={(size) => {
            setPageSize(size);
            setCurrentPage(1);
          }}
        />
      </div>
    </div>
  );
};
