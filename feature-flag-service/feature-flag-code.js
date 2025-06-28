const express = require('express');
const jwt = require('jsonwebtoken');
const redis = require('redis');

// Configuration (in production, fetch from Secrets Manager)
const JWT_SECRET = process.env.JWT_SECRET || 'mysecret';
const REDIS_URL = process.env.REDIS_URL || 'redis://localhost:6379';

// Redis client
const client = redis.createClient({ url: REDIS_URL });
client.connect().catch(console.error);

const app = express();
app.use(express.json());

// JWT authentication middleware
app.use((req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.status(401).json({ error: 'Missing token' });
  try {
    jwt.verify(token, JWT_SECRET);
    next();
  } catch (err) {
    return res.status(401).json({ error: 'Invalid token' });
  }
});

// GET /flags - list all feature flags
app.get('/flags', async (req, res) => {
  try {
    const keys = await client.keys('feature:*');
    const flags = {};
    for (let key of keys) {
      const data = await client.hGetAll(key);
      flags[key] = data;
    }
    res.json(flags);
  } catch (err) {
    res.status(500).json({ error: 'Failed to fetch flags' });
  }
});

// POST /flags - create a new feature flag
app.post('/flags', async (req, res) => {
  const { name, enabled } = req.body;
  if (!name || enabled == null) {
    return res.status(400).json({ error: 'Missing name or enabled' });
  }
  const key = `feature:${name}`;
  try {
    await client.hSet(key, 'enabled', enabled ? 'true' : 'false');
    res.status(201).json({ name, enabled });
  } catch (err) {
    res.status(500).json({ error: 'Failed to create flag' });
  }
});

// PATCH /flags/:name - update an existing feature flag
app.patch('/flags/:name', async (req, res) => {
  const { name } = req.params;
  const { enabled } = req.body;
  if (enabled == null) {
    return res.status(400).json({ error: 'Missing enabled' });
  }
  const key = `feature:${name}`;
  try {
    const exists = await client.exists(key);
    if (!exists) {
      return res.status(404).json({ error: 'Flag not found' });
    }
    await client.hSet(key, 'enabled', enabled ? 'true' : 'false');
    res.json({ name, enabled });
  } catch (err) {
    res.status(500).json({ error: 'Failed to update flag' });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Feature-Flag service listening on port ${PORT}`);
});
