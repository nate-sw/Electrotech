const Websocket = require('ws');
const { exec } = require('child_process');
// Set the appropriate server address and port number here
const ws = new Websocket('ws://192.168.0.7:6432');


// Function to send a request for temperature reading
function sendTemperatureRequest() {
  // Send a request for temperature reading by sending the prefix 't'
  ws.send('t');
}

// Function to calculate the milliseconds until the next interval
function getMillisecondsUntilNextInterval() {
  const now = new Date();
  const minutes = now.getMinutes();
  const seconds = now.getSeconds();

  // Calculate the milliseconds until the next 10-minute interval
  return ((5 - (minutes % 5)) * 60 - seconds) * 1000;
}

// Function to start the interval timer
function startIntervalTimer() {
  const millisecondsUntilNextInterval = getMillisecondsUntilNextInterval();

  setTimeout(function() {
    sendTemperatureRequest();
    startIntervalTimer();
  }, millisecondsUntilNextInterval);
}



ws.on('open', function open() {
    console.log('Connected to WebSocket server');
    startIntervalTimer();
});

ws.on('message', function incoming(data) {
    console.log('Received data from server:', data);

    // Pass the received tag data to a PHP script for processing
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

        