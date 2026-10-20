
CREATE TABLE IF NOT EXISTS mods (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    slug VARCHAR(100) UNIQUE NOT NULL,
    name VARCHAR(160) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'planned'
        CHECK (status IN ('planned','development','testing','released')),
    game VARCHAR(8) NOT NULL,
    category VARCHAR(50) NOT NULL DEFAULT 'other',
    version VARCHAR(40) NOT NULL DEFAULT '1.0',
    release_date DATE,
    mod_type VARCHAR(10) NOT NULL DEFAULT 'free'
        CHECK (mod_type IN ('free','paid')),
    price_cents INTEGER NOT NULL DEFAULT 0
        CHECK (price_cents >= 0),
    currency CHAR(3) NOT NULL DEFAULT 'EUR',
    description TEXT NOT NULL DEFAULT '',
    image_url TEXT NOT NULL DEFAULT '',
    gallery_urls JSONB NOT NULL DEFAULT '[]'::jsonb,
    free_download_url TEXT NOT NULL DEFAULT '',
    private_file_key VARCHAR(255),
    features JSONB NOT NULL DEFAULT '[]'::jsonb,
    authors VARCHAR(160) NOT NULL DEFAULT 'Agro_Modex',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS applications (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL,
    country VARCHAR(80) NOT NULL DEFAULT '',
    role VARCHAR(80) NOT NULL,
    experience TEXT NOT NULL DEFAULT '',
    consent_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS contact_messages (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL,
    subject VARCHAR(120) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS mods_status_idx
    ON mods(status);

CREATE INDEX IF NOT EXISTS mods_created_idx
    ON mods(created_at DESC);
