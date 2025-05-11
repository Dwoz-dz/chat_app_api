const bcrypt = require('bcrypt');
const pool = require('./db');

async function upsertUser() {
  const username = 'admin';
  const fullName = 'محسن نستان';
  const rawPassword = '123456';

  const hashedPassword = await bcrypt.hash(rawPassword, 10);

  const query = `
    INSERT INTO users (username, password, full_name)
    VALUES ($1, $2, $3)
    ON CONFLICT (username)
    DO UPDATE SET password = EXCLUDED.password, full_name = EXCLUDED.full_name
  `;

  try {
    await pool.query(query, [username, hashedPassword, fullName]);
    console.log('✅ تم إدخال أو تحديث المستخدم بنجاح');
  } catch (err) {
    console.error('❌ خطأ:', err.message);
  } finally {
    pool.end();
  }
}

upsertUser();