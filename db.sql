CREATE DATABASE database_name;

USE database_name;

CREATE TABLE epl_table (
    position INT PRIMARY KEY,
    team VARCHAR(50),
    played INT,
    wins INT,
    draws INT,
    losses INT,
    goals_for INT,
    goals_against INT,
    goal_difference INT,
    points INT,
    last_5_games VARCHAR(20)
);

INSERT INTO epl_table (position, team, played, wins, draws, losses, goals_for, goals_against, goal_difference, points, last_5_games) VALUES
(1, 'Team A', 10, 8, 1, 1, 25, 10, 15, 25, 'W W W D W'),
(2, 'Team B', 10, 7, 2, 1, 20, 8, 12, 23, 'W W W W D'),
(3, 'Team C', 10, 6, 3, 1, 18, 9, 9, 21, 'W W D W L'),
(4, 'Team D', 10, 5, 4, 1, 15, 10, 5, 19, 'W D W L W');

CREATE TABLE teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(50) NOT NULL
);

CREATE TABLE players (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    player_name VARCHAR(50) NOT NULL,
    team_id INT,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
);

CREATE TABLE matches (
    match_id INT PRIMARY KEY AUTO_INCREMENT,
    home_team_id INT,
    away_team_id INT,
    home_team_goals INT,
    away_team_goals INT,
    match_date DATE,
    home_team_red_cards INT DEFAULT 0,
    away_team_red_cards INT DEFAULT 0,
    home_team_yellow_cards INT DEFAULT 0,
    away_team_yellow_cards INT DEFAULT 0,
    FOREIGN KEY (home_team_id) REFERENCES teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES teams(team_id)
);

CREATE TABLE match_events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    match_id INT,
    player_id INT,
    event_type VARCHAR(20),
    event_time TIME,
    FOREIGN KEY (match_id) REFERENCES matches(match_id),
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

INSERT INTO teams (team_name) VALUES
('Blue'),
('Green'),
('Red'),
('Yellow');

INSERT INTO players (player_name, team_id) VALUES
('Player 1', 1),
('Player 2', 1),
('Player 3', 2),
('Player 4', 2),
('Player 5', 3),
('Player 6', 3),
('Player 7', 4),
('Player 8', 4);

INSERT INTO matches (home_team_id, away_team_id, home_team_goals, away_team_goals, home_team_red_cards, away_team_red_cards, home_team_yellow_cards, away_team_yellow_cards, match_date) VALUES
(1, 2, 3, 1, 1, 0, 2, 1, '2023-10-01'),
(3, 4, 2, 2, 0, 1, 1, 2, '2023-10-02'),
(1, 3, 1, 0, 0, 0, 1, 1, '2023-10-03'),
(2, 4, 2, 3, 1, 1, 2, 3, '2023-10-04');

INSERT INTO match_events (match_id, player_id, event_type, event_time) VALUES
(1, 1, 'goal', '00:15:00'),
(1, 2, 'yellow_card', '00:30:00'),
(1, 3, 'red_card', '00:45:00'),
(2, 5, 'goal', '00:20:00'),
(2, 6, 'yellow_card', '00:25:00'),
(2, 7, 'red_card', '00:50:00'),
(3, 1, 'goal', '00:10:00'),
(3, 4, 'yellow_card', '00:35:00'),
(4, 3, 'goal', '00:05:00'),
(4, 8, 'red_card', '00:55:00');

DELIMITER //

CREATE TRIGGER after_match_insert
AFTER INSERT ON matches
FOR EACH ROW
BEGIN
    DECLARE home_team_points INT;
    DECLARE away_team_points INT;
    DECLARE home_team_goal_diff INT;
    DECLARE away_team_goal_diff INT;

    IF NEW.home_team_goals > NEW.away_team_goals THEN
        SET home_team_points = 3;
        SET away_team_points = 0;
    ELSEIF NEW.home_team_goals < NEW.away_team_goals THEN
        SET home_team_points = 0;
        SET away_team_points = 3;
    ELSE
        SET home_team_points = 1;
        SET away_team_points = 1;
    END IF;

    SET home_team_goal_diff = NEW.home_team_goals - NEW.away_team_goals;
    SET away_team_goal_diff = NEW.away_team_goals - NEW.home_team_goals;

    UPDATE epl_table
    SET played = played + 1,
        wins = wins + (home_team_points = 3),
        draws = draws + (home_team_points = 1),
        losses = losses + (home_team_points = 0),
        goals_for = goals_for + NEW.home_team_goals,
        goals_against = goals_against + NEW.away_team_goals,
        goal_difference = goal_difference + home_team_goal_diff,
        points = points + home_team_points
    WHERE team = (SELECT team_name FROM teams WHERE team_id = NEW.home_team_id);

    UPDATE epl_table
    SET played = played + 1,
        wins = wins + (away_team_points = 3),
        draws = draws + (away_team_points = 1),
        losses = losses + (away_team_points = 0),
        goals_for = goals_for + NEW.away_team_goals,
        goals_against = goals_against + NEW.home_team_goals,
        goal_difference = goal_difference + away_team_goal_diff,
        points = points + away_team_points
    WHERE team = (SELECT team_name FROM teams WHERE team_id = NEW.away_team_id);
END //

DELIMITER ;
