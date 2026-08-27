//
//  QuotesCMS.tsx
//  RiseAdmin
//
//  Quotes catalog management with search, multi-filtering, and pagination
//

import React, { useState, useMemo } from 'react';
import { Icons } from '../common/Icons.js';
import { Pagination } from '../common/Pagination.js';
import { AdminQuote } from '../../types/admin.types.js';
import { RISE_CATEGORIES } from '../../config/constants.js';

interface QuotesCMSProps {
  quotes: AdminQuote[];
  filter: string;
  onFilterChange: (category: string) => void;
  onOpenCreate: () => void;
  onDeleteQuote: (id: string) => void;
}

export const QuotesCMS: React.FC<QuotesCMSProps> = ({
  quotes,
  filter,
  onFilterChange,
  onOpenCreate,
  onDeleteQuote,
}) => {
  const [searchTerm, setSearchTerm] = useState('');
  const [featuredFilter, setFeaturedFilter] = useState<'ALL' | 'FEATURED' | 'STANDARD'>('ALL');
  const [currentPage, setCurrentPage] = useState(1);
  const [pageSize, setPageSize] = useState(10);

  // Multi-attribute Filter
  const filtered = useMemo(() => {
    return quotes.filter((q) => {
      const matchCategory = !filter || q.category.toLowerCase() === filter.toLowerCase();
      const matchFeatured =
        featuredFilter === 'ALL' ||
        (featuredFilter === 'FEATURED' && q.isFeatured) ||
        (featuredFilter === 'STANDARD' && !q.isFeatured);
      const matchSearch =
        !searchTerm ||
        q.quote.toLowerCase().includes(searchTerm.toLowerCase()) ||
        q.author.toLowerCase().includes(searchTerm.toLowerCase());

      return matchCategory && matchFeatured && matchSearch;
    });
  }, [quotes, filter, featuredFilter, searchTerm]);

  // Paginated Slicing
  const paginatedQuotes = useMemo(() => {
    const start = (currentPage - 1) * pageSize;
    return filtered.slice(start, start + pageSize);
  }, [filtered, currentPage, pageSize]);

  return (
    <div>
      <div className="header-row">
        <div>
          <h1 className="view-title">Quotes & Thoughts CMS</h1>
          <p className="view-subtitle">Curate daily wisdom catalog, artwork backgrounds, and assign Day of Year rotations</p>
        </div>
        <button className="btn btn-primary btn-sm" onClick={onOpenCreate}>
          <Icons.Plus />
          <span>Add Quote</span>
        </button>
      </div>

      <div className="flat-card">
        {/* Advanced Filters & Search Bar */}
        <div className="flat-card-header">
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', flex: 1, minWidth: '240px' }}>
            <div className="search-input-group" style={{ width: '100%', maxWidth: '280px' }}>
              <Icons.Search />
              <input
                type="text"
                placeholder="Search quotes, authors..."
                value={searchTerm}
                onChange={(e) => {
                  setSearchTerm(e.target.value);
                  setCurrentPage(1);
                }}
              />
            </div>
          </div>

          <div className="filter-row" style={{ flexWrap: 'wrap', gap: '8px' }}>
            {/* Category Filter */}
            <select
              className="flat-select"
              value={filter}
              onChange={(e) => {
                onFilterChange(e.target.value);
                setCurrentPage(1);
              }}
            >
              <option value="">All 16 Categories</option>
              {RISE_CATEGORIES.map((c) => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>

            {/* Featured Filter */}
            <select
              className="flat-select"
              value={featuredFilter}
              onChange={(e) => {
                setFeaturedFilter(e.target.value as any);
                setCurrentPage(1);
              }}
            >
              <option value="ALL">All Statuses</option>
              <option value="FEATURED">★ Featured Only</option>
              <option value="STANDARD">Standard Catalog</option>
            </select>
          </div>
        </div>

        {/* Data Table */}
        <table className="flat-table">
          <thead>
            <tr>
              <th>Quote & Artwork</th>
              <th>Author</th>
              <th>Category</th>
              <th>Day of Year</th>
              <th>Featured</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {paginatedQuotes.length === 0 ? (
              <tr>
                <td colSpan={6} style={{ textAlign: 'center', padding: '32px', color: '#64748b' }}>
                  No quotes found matching the selected filters.
                </td>
              </tr>
            ) : (
              paginatedQuotes.map((q) => (
                <tr key={q.id}>
                  <td style={{ color: '#fff', maxWidth: '340px' }}>
                    <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
                      <div
                        style={{
                          width: '28px',
                          height: '28px',
                          borderRadius: '3px',
                          background: q.assetName?.startsWith('http')
                            ? `url(${q.assetName}) center/cover no-repeat`
                            : 'linear-gradient(135deg, #1E2738 0%, #0F172A 100%)',
                          border: '1px solid #1E2738',
                          flexShrink: 0,
                        }}
                        title={`Artwork: ${q.assetName || 'Default Marble'}`}
                      ></div>
                      <div>
                        <div style={{ fontStyle: 'italic' }}>"{q.quote}"</div>
                        <div style={{ fontSize: '10.5px', color: '#64748b', marginTop: '2px' }}>
                          Artwork: {q.assetName || 'onboarding_motivation_bg'}
                        </div>
                      </div>
                    </div>
                  </td>
                  <td style={{ fontWeight: 600 }}>{q.author}</td>
                  <td><span className="pill-badge pill-amber">{q.category}</span></td>
                  <td><span className="pill-badge pill-slate">Day {q.dayOfYear || 'Auto'}</span></td>
                  <td>{q.isFeatured ? <span className="pill-badge pill-emerald">Featured</span> : '-'}</td>
                  <td>
                    <button className="btn btn-danger btn-sm" onClick={() => onDeleteQuote(q.id)}>
                      Delete
                    </button>
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
