const Websocket = require('ws');
const { exec } = require('child_process');
// Set the appropriate server address and port number here
const ws = new Websocket('ws://192.168.0.7:6432');

ws.on('open', function open() {
    console.log('Connected to WebSocket server');
});

ws.on('message', function incoming(data) {
    console.log('Received data from server:', data);
  
    // Pass the received data to a PHP script for processing
    exec(`php ../includes/entry.inc.php "${data}"`, (error, stdout, stderr) => {
      if (error) {
        console.error(`Error executing PHP script: ${error.message}`);
        return;
      }
      if (stderr) {
        console.error(`PHP script error: ${stderr}`);
        return;
      }
      
    });
  });

ws.on('close', function close() {
    console.log('Connection to WebSocket server closed');
});

        