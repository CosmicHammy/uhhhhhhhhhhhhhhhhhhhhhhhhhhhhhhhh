
const express = require('express');
const mysql = require('mysql');
const app = express();
const port = 3000;

const db = mysql.createConnection({
    host: 'nfl1mysql-nfl1.k.aivencloud.com',
    user: 'avnadmin',
    password: 'AVNS_XgVrDMM1R1wpkq1KXQd',
    database: 'football_league'
});

db.connect(err => {
    if (err) throw err;
    console.log('Connected to database');
});

app.get('/api/table', (req, res) => {
    const query = 'SELECT * FROM league_table ORDER BY position';
    db.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

app.get('/api/mini-table', (req, res) => {
    const query = 'SELECT team, mp, w, d, l, gd, pts FROM league_table ORDER BY position LIMIT 5';
    db.query(query, (err, results) => {
        if (err) throw err;
        res.json(results);
    });
});

app.listen(port, () => {
    console.log(`Server running at https://nfl1mysql-nfl1.k.aivencloud.com:${22605}`);
});