const bcrypt = require('bcryptjs');
const pool = require('./db');

const users = [
  { username: 'admin', password: '123456', full_name: 'محسن نستان', role: 'admin' },
  { username: 'khalil', password: 'azerty', full_name: 'خليل برون', role: 'user' },
  { username: 'fouad', password: 'fouad123', full_name: 'فؤاد زينو', role: 'user' },
  { username: 'karim', password: 'karimpass', full_name: 'كريم بوبكر', role: 'moderator' }
];

async function seedUsers() {
  for (const user of users) {
    const hashedPassword = await bcrypt.hash(user.password, 10);

    try {
      await pool.query(
        'INSERT INTO users (username, password, full_name, role) VALUES ($1, $2, $3, $4)',
        [user.username, hashedPassword, user.full_name, user.role]
      );
      console.log(`✅ تم إدخال المستخدم: ${user.username}`);
    } catch (err) {
      console.error(`❌ خطأ عند إضافة ${user.username}:`, err.message);
    }
  }

  pool.end(); // غلق الاتصال بعد الانتهاء
}

seedUsers();