CREATE TABLE Board (
    Id BLOB NOT NULL,

    BoardNumber INT NOT NULL,
    StartingClock INT,
    CurrentClock INT,
    
    PlayerIdWhite BLOB,
    PlayerIdBlack BLOB,

    GameId BLOB,

    PRIMARY KEY (Id),
    FOREIGN KEY (PlayerIdWhite) REFERENCES Players(PlayedId),
    FOREIGN KEY (PlayerIdBlack) REFERENCES Games(PlayedId)
);

CREATE TABLE Players (
    Id BLOB NOT NULL,

    Name TEXT,
    Rating INT,

    PRIMARY KEY (Id)
);

CREATE TABLE Games (
    Id BLOB NOT NULL,

    Pgn TEXT NOT NULL,
    Result INT NOT NULL,

    PlayerIdBlack BLOB,
    PlayerIdWhite BLOB,

    PRIMARY KEY (Id),
    FOREIGN KEY (PlayerIdWhite) REFERENCES Players(PlayedId),
    FOREIGN KEY (PlayerIdBlack) REFERENCES Players(PlayedId),
);