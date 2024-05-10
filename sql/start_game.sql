-- User should suplement the header
INSERT INTO Games (Pgn, PlayerIdWhite, PlayerIdBlack) VALUES (?, ?, ?);

UPDATE Boards 
  SET BoardNumber = ?,
    StartingClockWhite = ?,
    StartingClockBlack = ?,
    CurrentClockWhite = ?,
    CurrentClockBlack = ?,
    IncrementWhite = ?,
    IncrementBlack = ?,
    IncrementAfterMoveReached = ?,
    IncrementAfterMoveReachedAt = ?,
    GameId = (SELECT GameId FROM Games LIMIT 1 ORDER BY Id DESC)
  WHERE
    BoardId = ?;
