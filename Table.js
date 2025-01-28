import React, { useState, useEffect } from 'react';

const Table = () => {
    const [teams, setTeams] = useState([]);

    useEffect(() => {
        // Fetch data from an API or define it statically
        const fetchData = async () => {
            const data = [
                { id: 1, name: 'Team A', played: 10, won: 8, drawn: 1, lost: 1, goalsFor: 25, goalsAgainst: 10, goalDifference: 15, points: 25, form: 'W W W W W' },
                { id: 2, name: 'Team B', played: 10, won: 7, drawn: 2, lost: 1, goalsFor: 20, goalsAgainst: 8, goalDifference: 12, points: 23, form: 'W W W W D' },
                { id: 3, name: 'Team C', played: 10, won: 6, drawn: 3, lost: 1, goalsFor: 18, goalsAgainst: 9, goalDifference: 9, points: 21, form: 'W W D W W' },
                // Add more teams as needed
            ];
            setTeams(data);
        };

        fetchData();
    }, []);

    return (
        <table>
            <thead>
                <tr>
                    <th>Position</th>
                    <th>Team</th>
                    <th>Played</th>
                    <th>Won</th>
                    <th>Drawn</th>
                    <th>Lost</th>
                    <th>Goals For</th>
                    <th>Goals Against</th>
                    <th>Goal Difference</th>
                    <th>Points</th>
                    <th>Form</th>
                </tr>
            </thead>
            <tbody>
                {teams.map((team, index) => (
                    <tr key={team.id} className={`team-${team.name.toLowerCase().replace(' ', '-')}`}>
                        <td>{index + 1}</td>
                        <td>{team.name}</td>
                        <td>{team.played}</td>
                        <td>{team.won}</td>
                        <td>{team.drawn}</td>
                        <td>{team.lost}</td>
                        <td>{team.goalsFor}</td>
                        <td>{team.goalsAgainst}</td>
                        <td>{team.goalDifference}</td>
                        <td>{team.points}</td>
                        <td>{team.form}</td>
                    </tr>
                ))}
            </tbody>
        </table>
    );
};

export default Table;