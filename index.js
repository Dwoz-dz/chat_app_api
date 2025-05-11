const express = require('express');
const http = require('http');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const usersRoutes = require('./routes/users');

const app = express();
const server = http.createServer(app);
const { Server } = require('socket.io');

// إعداد socket.io
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

const PORT = process.env.PORT || 5001;

// middlewares
app.use(cors());
app.use(bodyParser.json());

// routes
app.use('/api', authRoutes);
app.use('/api', usersRoutes);

// socket.io events
io.on('connection', (socket) => {
  console.log(`⚡️ مستخدم متصل: ${socket.id}`);

  socket.on('send_message', (data) => {
    io.emit('receive_message', data);
  });

  socket.on('disconnect', () => {
    console.log(`⛔️ مستخدم قطع الاتصال: ${socket.id}`);
  });
});

app.get('/', (req, res) => {
  res.send('✅ API و Socket.io راهي خدامة');
});

server.listen(PORT, () => {
  console.log(`✅ Server خدام على http://localhost:${PORT}`);
});