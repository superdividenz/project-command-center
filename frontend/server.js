const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;

// Read the HTML file
let indexHtml = fs.readFileSync(path.join(__dirname, 'index.html'), 'utf8');

// Serve the HTML file
app.get('/', (req, res) => {
  res.send(indexHtml);
});

// Serve static files if needed
app.use(express.static(path.join(__dirname)));

// For all other routes, serve index.html (SPA)
app.get('*', (req, res) => {
  res.send(indexHtml);
});

app.listen(PORT, () => {
  console.log(`🚀 Command Center Frontend running on port ${PORT}`);
  console.log(`🌐 Open in browser: http://localhost:${PORT}`);
  console.log(`🔌 Frontend connects directly to Supabase`);
});