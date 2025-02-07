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

DELIMITER //
CREATE PROCEDURE add_player(
    IN player_name VARCHAR(50),
    IN team_name VARCHAR(50)
)