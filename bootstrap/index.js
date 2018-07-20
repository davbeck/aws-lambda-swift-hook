const spawn = require('child_process').spawn;
const net = require('net');
const EventEmitter = require('events');

// for errors we can't (or don't want to) recover from, we'll crash and let lambda restart us

// we only care about the first connection
// this returns a promise that resolves once a connection is established
function startServer() {
  return new Promise((resolve, reject) => {
    const server = net.createServer(socket => {
      resolve(socket);
    });
    server.on('error', err => {
      console.error('listener failed', error);
      exit(1);
    });
    server.listen('/tmp/swift.sock');
  });
}

// spawn the child process
function startProcess() {
  this.main = spawn('libraries/ld-linux-x86-64.so.2', ['--library-path', 'libraries', './main']);
  this.main.on('exit', (code, signal) => {
    console.error('child exit', code, signal);
    process.exit(1);
  });
  this.main.on('error', error => {
    console.error('child error', error);
    process.exit(1);
  });

  // forward logging
  this.main.stdout.pipe(process.stdout);
  this.main.stderr.pipe(process.stderr);
}

async function start() {
  // the order here is very important
  // the swift process will immediately start connecting to the socket
  // so we need to already be listening when it starts
  // but notice that we don't await on the socket until after we star the child
  const socketPromise = startServer();
  startProcess();

  // wait for the child to connect to our socket
  const socket = await socketPromise;

  return new Host(socket);
}

class Host extends EventEmitter {
  constructor(socket) {
    super();

    this.socket = socket;
    this.setupSocket();
  }

  setupSocket() {
    // we need to track state since a response might be broken up into multiple packets
    let messageType = null;
    let messageLength = null;
    let buffer = null;
    this.socket.on('data', data => {
      // add the latest packet to our buffer
      buffer = buffer ? Buffer.concat([buffer, data]) : data;

      // if we haven't read the type and we have enough bytes to do so
      if (messageType === null && buffer.length >= 1) {
        messageType = buffer.readUInt8(0);
      }
      // if we haven't read the length and we have enough bytes to do so
      if (messageLength === null && buffer.length >= 5) {
        messageLength = buffer.readInt32BE(1);
      }
      // if we have all the bytes we need, read the json data
      if (messageType !== null && buffer.length >= 5 + messageLength) {
        const json = buffer.toString('utf8', 5, 5 + messageLength);
        const message = JSON.parse(json);

        if (messageType === 1) {
          this.emit('success', message);
        } else {
          this.emit('error', message);
        }

        // reset for the next message
        // because we use a serial request/response prototocol,
        // we don't have to worry about buffer having multiple messages
        messageType = null;
        messageLength = null;
        buffer = null;
      }
    });

    this.socket.on('close', error => {
      console.error('socket closed', error);
      process.exit(1);
    });
    this.socket.on('error', function(error) {
      console.error('socket error', error);
      process.exit(1);
    });
  }

  writeJSON(object) {
    // we first send 4 bytes representing the length of the json body
    var jsonBuffer = new Buffer(JSON.stringify(object), 'binary');
    let countBuffer = new Buffer(4);
    countBuffer.writeUInt32BE(jsonBuffer.length, 0);
    this.socket.write(countBuffer);
    this.socket.write(jsonBuffer);
  }

  readResponse() {
    return new Promise((resolve, reject) => {
      this.once('success', message => {
        resolve(message);
      });
      this.once('event', error => {
        reject(error);
      });
    });
  }

  async handler(event, context) {
    // send both the context and the event
    this.writeJSON(context);
    this.writeJSON(event);

    // then wait for a reply
    const message = await readResponse();

    return message;
  }
}

const host = start();
exports.handler = async (event, context) => {
  // on first launch our handler might get called a split second before the child process launches and connects
  // we wait on the connection to be ready just in case
  // on subsequent runs this should return the host almost immediately
  // then we await on the host's handler
  return await (await host).handler(event, context);
};
