// db.js
const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'chat_app_db',
  password: 'Sn2008', // غيّرها إذا بدلتها من pgAdmin
  port: 5432,
});

module.exports = pool;