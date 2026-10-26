CREATE TABLE IF NOT EXISTS products (
 id TEXT PRIMARY KEY, title TEXT NOT NULL, description TEXT NOT NULL,
 category TEXT NOT NULL, country TEXT NOT NULL, era TEXT NOT NULL, image TEXT NOT NULL,
 cost_cents INTEGER NOT NULL CHECK(cost_cents>=0), markup_bps INTEGER NOT NULL DEFAULT 1500,
 source_url TEXT NOT NULL UNIQUE, permission_reference TEXT NOT NULL,
 status TEXT NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','published','sold','archived')),
 expires_at TEXT NOT NULL, updated_at TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS enquiries (
 id TEXT PRIMARY KEY, product_id TEXT NOT NULL REFERENCES products(id),
 email TEXT NOT NULL, message TEXT NOT NULL, created_at TEXT NOT NULL
);
CREATE INDEX IF NOT EXISTS products_public ON products(status,expires_at);
