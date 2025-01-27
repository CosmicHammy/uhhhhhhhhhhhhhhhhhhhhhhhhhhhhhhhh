<!DOCTYPE html>
<html lang="en">
<head>
    <!-- ...existing code... -->
    <style>
        /* ...existing code... */
    </style>
</head>
<body>
    <h1>NFL Table</h1>
    <table>
        <thead>
            <!-- ...existing code... -->
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
