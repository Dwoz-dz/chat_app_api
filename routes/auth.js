const express = require('express');
const router = express.Router();
const pool = require('../db');
const bcrypt = require('bcryptjs'); // تم التبديل من bcrypt إلى bcryptjs
const jwt = require('jsonwebtoken');
require('dotenv').config();

// سر JWT
const SECRET = process.env.JWT_SECRET || 'MohcenAppSuperSecretKey';

// =======================
// تسجيل الدخول
// =======================
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: 'يرجى ملء جميع الحقول' });
  }

  try {
    const result = await pool.query('SELECT * FROM users WHERE username = $1', [username]);

    if (result.rows.length === 0) {
      return res.status(401).json({ message: '❌ المستخدم غير موجود' });
    }

    const user = result.rows[0];
    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(401).json({ message: '❌ كلمة السر غير صحيحة' });
    }

    // تحديث حالة الاتصال
    await pool.query('UPDATE users SET is_online = TRUE WHERE id = $1', [user.id]);

    // توليد التوكن
    const token = jwt.sign(
      { id: user.id, username: user.username },
      SECRET,
      { expiresIn: '365d' }
    );

    res.json({
      message: '✅ تم تسجيل الدخول بنجاح',
      token,
      user: {
        id: user.id,
        username: user.username,
        full_name: user.full_name
      }
    });

  } catch (err) {
    console.error('❌ خطأ في تسجيل الدخول:', err.message);
    res.status(500).json({ error: '⚠️ مشكل داخلي في الخادم' });
  }
});

// =======================
// تسجيل الخروج
// =======================
router.post('/logout', async (req, res) => {
  const { username } = req.body;

  if (!username) {
    return res.status(400).json({ message: 'اسم المستخدم مطلوب' });
  }

  try {
    const result = await pool.query(
      'UPDATE users SET is_online = FALSE WHERE username = $1',
      [username]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: '❌ المستخدم غير موجود' });
    }

    res.json({ message: '✅ تم تسجيل الخروج بنجاح' });

  } catch (err) {
    console.error('❌ خطأ في تسجيل الخروج:', err.message);
    res.status(500).json({ message: '⚠️ خطأ في الخادم' });
  }
});

module.exports = router;