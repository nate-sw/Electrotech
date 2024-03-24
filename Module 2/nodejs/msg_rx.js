const Websocket = require('ws');
const { exec } = require('child_process');

const wss = new Websocket.Server({ port: 6432 });

wss.on('connection', function connection(ws) {
    console.log('Client connected');

    ws.on('message', function incoming(message) {
        console.log('Received %s', message);

        exec(`php ../includes/entry.inc.php "${message}"`, (error, stdout, stderr) => {
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
});