const bcrypt = require('bcrypt');
const pool = require('./db');

async function seedUser() {
  const hashedPassword = await bcrypt.hash('123456', 10);

  try {
    await pool.query(
      'INSERT INTO users (username, password, full_name) VALUES ($1, $2, $3)',
      ['admin', hashedPassword, 'محسن نستان']
    );
    console.log('✅ تم إدخال المستخدم بنجاح');
  } catch (err) {
    console.error('❌ خطأ:', err.message);
  } finally {
    pool.end(); // غلق الاتصال
  }
}

seedUser();