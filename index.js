// index.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const http = require('http');
const { Server } = require('socket.io');
require('dotenv').config();

const authRoutes = require('./routes/auth');
const usersRoutes = require('./routes/users');

const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

// ========== Middlewares ==========
app.use(cors());
app.use(bodyParser.json());

// ========== API Routes ==========
app.use('/api', authRoutes);
app.use('/api', usersRoutes);

// ========== WebSocket ==========
io.on('connection', (socket) => {
  console.log('🟢 مستخدم اتصل عبر WebSocket');

  socket.on('chat_message', (msg) => {
    console.log('📩 رسالة:', msg);
    io.emit('chat_message', msg); // إرسال للجميع
  });

  socket.on('disconnect', () => {
    console.log('🔴 المستخدم قطع الاتصال');
  });
});

// ========== Test Route ==========
app.get('/', (req, res) => {
  res.send('✅ API راهي خدامة ومربوطة');
});

// ========== Start Server ==========
const PORT = process.env.PORT || 5001;
server.listen(PORT, '0.0.0.0', () => {
  console.log(`✅ الخادم شغال على: http://localhost:${PORT}`);
});