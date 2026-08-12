const http = require('http');

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/html' });
    const prNumber = process.env.PR_NUMBER || 'Unknown';
    const time = new Date().toISOString();
    
    res.end(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>PR Preview</title>
            <style>
                body { font-family: system-ui, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; background-color: #f7f9fc; }
                .container { text-align: center; background: white; padding: 3rem; border-radius: 1rem; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
                h1 { color: #2d3748; }
                .meta { color: #718096; margin-top: 1rem; font-size: 0.875rem; }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🚀 Hello from PR Preview Environment!</h1>
                <h2>Pull Request #${prNumber}</h2>
                <div class="meta">Generated at: ${time}</div>
            </div>
        </body>
        </html>
    `);
});

server.listen(8080, () => {
    console.log('Server is running on port 8080');
});
