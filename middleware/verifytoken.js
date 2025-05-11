const jwt = require('jsonwebtoken');
require('dotenv').config();

const SECRET = process.env.JWT_SECRET || 'MohcenAppSuperSecretKey';

function verifyToken(req, res, next) {
  const authHeader = req.headers['authorization'];

  // Format: "Bearer token"
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'التوكن غير موجود' });
  }

  try {
    const decoded = jwt.verify(token, SECRET);
    req.user = decoded; // نحط المستخدم في req
    next(); // نكمل
  } catch (err) {
    res.status(403).json({ message: 'توكن غير صالح أو منتهي' });
  }
}

module.exports = verifyToken;