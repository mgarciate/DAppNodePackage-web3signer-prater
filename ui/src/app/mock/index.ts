import http from 'http';
import { IncomingMessage, ServerResponse } from 'http';

http
  .createServer((req: IncomingMessage, res: ServerResponse) => {
    // Set CORS headers
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Request-Method', '*');
    res.setHeader('Access-Control-Allow-Methods', '*');
    res.setHeader('Access-Control-Allow-Headers', '*');

    const url = req.url;
    const method = req.method;

    if (url === '/') {
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      res.end('Server mock');
    } else if (url === '/api/v1/eth2/publicKeys' && method === 'GET') {
      res.writeHead(200, {
        'Content-Type': 'application/json',
        Charset: 'utf-8',
      });
      const publicKeys = [
        '0x852a771165fd991e497e1a37fcaaac41a5dae7fa3e6c38b1c11a9be7203c7bac0d88ae067e0b053db72d0b2231339cb3',
        '0x8ac669f5180ae1de36db123114657437fd2cd3f51e838aa327d6739ff28907731462e0832fb9eb190972cfd652b2a775',
      ];
      res.end(JSON.stringify(publicKeys));
    } else if (url === '/upcheck' && method === 'GET') {
      res.writeHead(200, { 'Content-Type': 'text/plain' });
      res.end('OK');
    } else if (url === '/reload' && method === 'POST') {
    } else {
      res.writeHead(404, { 'Content-Type': 'text/plain' });
      res.end('resource not found');
    }
  })
  .listen(5000);
