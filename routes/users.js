const express = require('express');
const router = express.Router();
const pool = require('../db');

// جلب جميع المستخدمين مع الحالة وآخر ظهور
router.get('/users', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        id, 
        username, 
        full_name, 
        status, 
        to_char(last_seen, 'YYYY-MM-DD HH24:MI:SS') as last_seen
      FROM users 
      ORDER BY id ASC
    `);
    res.json({ users: result.rows });
  } catch (err) {
    console.error('❌ خطأ أثناء جلب المستخدمين:', err.message);
    res.status(500).json({ error: '⚠️ فشل في جلب المستخدمين' });
  }
});

// تحديث الحالة ووقت آخر ظهور
router.post('/users/update-status', async (req, res) => {
  const { id, status, last_seen } = req.body;

  if (!id) return res.status(400).json({ message: 'معرّف المستخدم مفقود' });

  try {
    await pool.query(
      'UPDATE users SET status = $1, last_seen = $2 WHERE id = $3',
      [status || 'متاح حالياً', last_seen || new Date(), id]
    );
    res.json({ message: '✅ تم تحديث الحالة والوقت' });
  } catch (err) {
    console.error('❌ خطأ أثناء التحديث:', err.message);
    res.status(500).json({ error: '⚠️ فشل في التحديث' });
  }
});

module.exports = router;