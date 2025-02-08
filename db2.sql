USE nfldb;

CREATE TABLE matches (
    match_id INT PRIMARY KEY,
    team_id INT,
    opponent_id INT,
    match_date DATE,
    location VARCHAR(100),
    status VARCHAR(10) -- 'upcoming', 'completed'
);

-- Reference past match info from match_results
ALTER TABLE matches
ADD CONSTRAINT fk_match_results
FOREIGN KEY (match_id) REFERENCES match_results(match_id);
CREATE TABLE match_results (
    match_id INT PRIMARY KEY,
    team_id INT,
    opponent_id INT,
    goals_for INT,
    goals_against INT,
    result VARCHAR(10) -- 'win', 'draw', 'loss'
);

CREATE TABLE nfl_table (
    team_id INT PRIMARY KEY,
    team VARCHAR(50),
    played INT,
    wins INT,
    draws INT,
    losses INT,
    goals_for INT,
    goals_against INT,
    goal_difference INT,
    points INT,
    position INT,
    last_5_games VARCHAR(20)
);

-- Trigger to update nfl_table after inserting a match result
CREATE TRIGGER update_nfl_table AFTER INSERT ON match_results
FOR EACH ROW
BEGIN
    -- Update the team's stats
    UPDATE nfl_table
    SET 
        played = played + 1,
        wins = wins + CASE WHEN NEW.result = 'win' THEN 1 ELSE 0 END,
        draws = draws + CASE WHEN NEW.result = 'draw' THEN 1 ELSE 0 END,
        losses = losses + CASE WHEN NEW.result = 'loss' THEN 1 ELSE 0 END,
        goals_for = goals_for + NEW.goals_for,
        goals_against = goals_against + NEW.goals_against,
        goal_difference = goals_for - goals_against,
        points = points + CASE 
            WHEN NEW.result = 'win' THEN 3
            WHEN NEW.result = 'draw' THEN 1
            ELSE 0
        END
    WHERE team_id = NEW.team_id;

    -- Update the opponent's stats
    UPDATE nfl_table
    SET 
        played = played + 1,
        wins = wins + CASE WHEN NEW.result = 'loss' THEN 1 ELSE 0 END,
        draws = draws + CASE WHEN NEW.result = 'draw' THEN 1 ELSE 0 END,
        losses = losses + CASE WHEN NEW.result = 'win' THEN 1 ELSE 0 END,
        goals_for = goals_for + NEW.goals_against,
        goals_against = goals_against + NEW.goals_for,
        goal_difference = goals_for - goals_against,
        points = points + CASE 
            WHEN NEW.result = 'loss' THEN 3
            WHEN NEW.result = 'draw' THEN 1
            ELSE 0
        END
    WHERE team_id = NEW.opponent_id;

    -- Update the position of all teams
    UPDATE nfl_table
    SET position = (
        SELECT ROW_NUMBER() OVER (ORDER BY points DESC, goal_difference DESC, goals_for DESC)
        FROM nfl_table
    );
END;