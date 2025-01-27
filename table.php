<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EPL Table</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:nth-child(1) {
            background-color: #FFD700; /* Gold for 1st place */
        }
        tr:nth-child(2) {
            background-color: #C0C0C0; /* Silver for 2nd place */
        }
        tr:nth-child(3) {
            background-color: #CD7F32; /* Bronze for 3rd place */
        }
        tr:nth-child(4) {
            background-color: #ADD8E6; /* Light blue for 4th place */
        }
        tr.team-blue {
            background-color: #ADD8E6; /* Light blue */
        }
        tr.team-green {
            background-color: #90EE90; /* Light green */
        }
        tr.team-yellow {
            background-color: #FFFFE0; /* Light yellow */
        }
        tr.team-orange {
            background-color: #FFDAB9; /* Light orange */
        }
    </style>
</head>
<body>
    <h1>NFL Table</h1>
    <table>
    <thead>
            <tr>
                <th>Position</th>
                <th>Team</th>
                <th>Played (P)</th>
                <th>Wins (W)</th>
                <th>Draws (D)</th>
                <th>Losses (L)</th>
                <th>Goals For (GF)</th>
                <th>Goals Against (GA)</th>
                <th>Goal Difference (GD)</th>
                <th>Points (Pts)</th>
                <th>Last 5 Games</th>
            </tr>
        </thead>
        <tbody>
            <?php
            // Database connection
            $servername = "localhost";
            $username = "username";
            $password = "password";
            $dbname = "database_name";

            // Create connection
            $conn = new mysqli($servername, $username, $password, $dbname);

            // Check connection
            if ($conn->connect_error) {
                die("Connection failed: " . $conn->connect_error);
            }

            // Fetch data from the database
            $sql = "SELECT position, team, played, wins, draws, losses, goals_for, goals_against, goal_difference, points, last_5_games FROM epl_table";
            $result = $conn->query($sql);

            if ($result->num_rows > 0) {
                // Output data of each row
                while($row = $result->fetch_assoc()) {
                    $teamClass = '';
                    switch ($row["team"]) {
                        case 'Team A':
                            $teamClass = 'team-blue';
                            break;
                        case 'Team B':
                            $teamClass = 'team-green';
                            break;
                        case 'Team C':
                            $teamClass = 'team-yellow';
                            break;
                        case 'Team D':
                            $teamClass = 'team-orange';
                            break;
                    }
                    echo "<tr class='$teamClass'>
                            <td>{$row['position']}</td>
                            <td>{$row['team']}</td>
                            <td>{$row['played']}</td>
                            <td>{$row['wins']}</td>
                            <td>{$row['draws']}</td>
                            <td>{$row['losses']}</td>
                            <td>{$row['goals_for']}</td>
                            <td>{$row['goals_against']}</td>
                            <td>{$row['goal_difference']}</td>
                            <td>{$row['points']}</td>
                            <td>{$row['last_5_games']}</td>
                          </tr>";
                }
            } else {
                echo "<tr><td colspan='11'>No data available</td></tr>";
            }
            $conn->close();
            ?>
        </tbody>
    </table>
</body>
</html>
