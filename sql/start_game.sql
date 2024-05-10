-- User should suplement the header
INSERT INTO Games (Pgn, PlayerIdWhite, PlayerIdBlack) VALUES (?, ?, ?);

UPDATE Boards 
    SET StartingClock = ?,
        CurrentClock = ?,
        PlayerIdWhite = ?,
        PlayerIdBlack = ?,
        GameId = SELECT GameId FROM Games LIMIT 1 ORDER BY Id DESC
    WHERE
        BoardId = ?;