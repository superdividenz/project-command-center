const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 3001;

const pool = process.env.DATABASE_URL
  ? new Pool({ connectionString: process.env.DATABASE_URL, ssl: { rejectUnauthorized: false } })
  : null;

app.use(express.json());

const health = (req, res) =>
  res.json({ status: 'ok', message: 'Backend running' });
app.get('/health', health);
app.get('/api/health', health);

app.listen(PORT, () => {
  console.log(`Backend running on port ${PORT}`);
});
