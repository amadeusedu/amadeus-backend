-- V1__identity.sql : initial Identity & Access schema
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL CHECK (email ~* '^[^@]+@[^@]+\.[^@]+$'),
  password_hash TEXT NOT NULL,
  status VARCHAR(10) NOT NULL CHECK (status IN ('PENDING','ACTIVE','LOCKED')),
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE profiles (
  user_id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  full_name TEXT NOT NULL,
  avatar_url TEXT,
  vce_subjects JSONB,
  bio TEXT,
  updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE roles (
  role VARCHAR(20) PRIMARY KEY
);

INSERT INTO roles(role) VALUES ('STUDENT'), ('TUTOR'), ('ADMIN')
ON CONFLICT DO NOTHING;

CREATE TABLE user_roles (
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  role VARCHAR(20) REFERENCES roles(role) ON DELETE CASCADE,
  PRIMARY KEY (user_id, role)
);

CREATE TABLE policies (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  subject TEXT NOT NULL,
  action TEXT NOT NULL,
  resource TEXT NOT NULL,
  effect VARCHAR(5) NOT NULL CHECK (effect IN ('ALLOW','DENY')),
  conditions JSONB,
  priority INT NOT NULL DEFAULT 100
);

CREATE TABLE refresh_tokens (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  token_hash TEXT NOT NULL,
  device_fingerprint TEXT,
  expires_at TIMESTAMP NOT NULL,
  issued_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indexes for quick lookups
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_profiles_updated_at ON profiles(updated_at);
CREATE INDEX idx_tokens_user ON refresh_tokens(user_id);