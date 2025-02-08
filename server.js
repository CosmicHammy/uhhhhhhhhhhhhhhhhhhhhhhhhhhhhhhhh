const express = require('express');
const mysql = require('mysql');
const app = express();

const connection = mysql.createConnection({
    host: 'nfl1mysql-nfl1.k.aivencloud.com', // Change to your MySQL host if needed (e.g., Aiven)
    user: 'avnadmin',
    password: 'AVNS_XgVrDMM1R1wpkq1KXQdyourpassword',
    database: 'nfl1db'
});

connection.connect();

app.get('/api/standings', (req, res) => {
    const query = `
        SELECT 
            s.team_id AS id,
            t.name AS name,
            s.matches_played AS played,
            s.wins AS won,
            s.draws AS drawn,
            s.losses AS lost,
            s.goals_for AS goalsFor,
            s.goals_against AS goalsAgainst,
            s.goal_difference AS goalDifference,
            s.points
        FROM 
            standings s
        JOIN 
            teams t ON s.team_id = t.id
        ORDER BY 
            s.points DESC, s.goal_difference DESC;
    `;
    
    connection.query(query, (error, results) => {
        if (error) {
            console.error("Error fetching standings:", error);
            res.status(500).json({ error: "Internal Server Error" });
            return;
        }
        res.json(results);
    });
});

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});
