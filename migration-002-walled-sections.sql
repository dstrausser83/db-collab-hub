-- db-collab-hub — migration 002: walled sections (David steering 2026-10-13)
-- Rooms gain an access class; room_grants carries per-identity section access.
-- Apply: wrangler d1 execute db-collab-hub-db --remote --file=migration-002-walled-sections.sql

ALTER TABLE rooms ADD COLUMN access TEXT NOT NULL DEFAULT 'public';
ALTER TABLE rooms ADD COLUMN grants_enabled INTEGER NOT NULL DEFAULT 1;

CREATE TABLE IF NOT EXISTS room_grants (
  id          TEXT PRIMARY KEY,
  room_id     TEXT NOT NULL REFERENCES rooms(id),
  identity_id TEXT NOT NULL REFERENCES identities(id),
  granted_by  TEXT,                              -- granting moderator's name
  created_at  TEXT NOT NULL,
  revoked_at  TEXT,                              -- NULL = grant active
  UNIQUE(room_id, identity_id)
);
CREATE INDEX IF NOT EXISTS idx_grants_identity ON room_grants(identity_id, revoked_at);

-- SAP: walled, grant door WORKING (David: "SAP needs to be open to access").
-- Odoo: walled and PARKED — exists in schema, grants disabled until unlocked.
INSERT OR IGNORE INTO rooms (id, slug, name, description, access, grants_enabled, created_at) VALUES
  ('room-sap',  'sap',  'SAP',  'SAP section — walled; access by grant (client / SAP work).', 'walled', 1, '2026-10-13T00:00:00.000Z'),
  ('room-odoo', 'odoo', 'Odoo', 'Odoo section — walled and parked; reserved for future use.', 'walled', 0, '2026-10-13T00:00:00.000Z');
