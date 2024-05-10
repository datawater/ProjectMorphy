UPDATE Games
    SET Result = ?
    WHERE Id =
        SELECT GameId FROM Boards WHERE Id = ?
