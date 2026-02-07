const http = require('http');
const PORT = process.env.PORT || 3001;
const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({ 
        message: 'Test server works!',
        timestamp: new Date().toISOString(),
        path: req.url
    }));
});
server.listen(PORT, () => {
    console.log(`✅ Test server listening on port ${PORT}`);
});
