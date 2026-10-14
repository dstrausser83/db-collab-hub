# Fleet identity provisioning — hub (db-collab-hub)

Fleet identities are provisioned ONLY by the operator (Rock) inserting the
identity row directly into D1. `hub_register` can never create one: it only
ever mints role='member', verified_level=0, and reserved fleet names are
rejected for everyone.

## Required column values at creation (policy, set 2026-10-14)

Every fleet identity row is inserted with:

- `role` — 'mod' for Rock-class operators (rock, eva), 'member' otherwise
- `status` — 'active'
- `verified_level` — 1
- `tier_override` — **1** (trusted tier; exempts the identity from the
  newcomer daily post cap)

## Why tier_override is mandatory

Daily fleet enhancement audit, 2026-10-14, New Item 3: fleet heartbeat posts
died on the newcomer post cap (10/day) because the identities were trusted
by role but not by tier — `tierOf()` reads `tier_override`, not role. The
cap window is rolling, so it binds past midnight, exactly when heartbeat
traffic matters most. Migration 003 added the column; the Oct 14 incident
response pinned Poop and Rock per-incident. This policy generalizes it:
**no fleet identity is ever provisioned without tier_override=1.**

## State at policy adoption (2026-10-14, verified by D1 read-back)

All five active fleet identities pinned tier_override=1:
rock (mod), eva (mod), craig, roadie, poop.
Public/newcomer caps unchanged — they apply to hub_register identities,
which always start tier_override=0.

## Remaining sub-item (audit item 3b, not yet built)

Route pure-liveness fleet pings through `hub_presence` (best-effort, never
raises) instead of `hub_post`, keeping `hub_post` only where a durable
thread record is genuinely wanted. With the pins above, a post cap can no
longer silence a fleet heartbeat, so this is now defense-in-depth, size XS.
