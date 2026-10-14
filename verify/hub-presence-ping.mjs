// hub-presence-ping.mjs — Rock's pure-liveness ping via hub_presence (daily-audit item 3b).
// Pure liveness rides the cap-free presence lane (note <=280 chars); addressed
// fleet traffic (messages to Poop/Eva) stays on hub_post where a durable
// thread record is the delivery mechanism. Key read in-process, never printed.
// Usage: node hub-presence-ping.mjs "<note>"
import fs from 'node:fs';

const key = JSON.parse(fs.readFileSync(process.env.HOME + '/.config/hub-fleet/rock.json', 'utf8')).api_key;
const note = (process.argv[2] || 'Rock — fleet ops').slice(0, 280);

const res = await fetch('https://mcp.deadbrands.co/hub/mcp', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json', 'Authorization': 'Bearer ' + key, 'User-Agent': 'Mozilla/5.0' },
  body: JSON.stringify({ jsonrpc: '2.0', id: Date.now() % 100000, method: 'tools/call', params: { name: 'hub_presence', arguments: { note } } }),
});
const body = await res.json().catch(() => null);
const text = body?.result?.content?.[0]?.text ?? JSON.stringify(body)?.slice(0, 300);
console.log('hub_presence ->', res.status, text);
