CREATE TABLE Boards (
  Id BLOB NOT NULL,

  BoardNumber INT,
  StartingClockWhite INT,
  StartingClockBlack INT,
  CurrentClockWhite INT,
  CurrentClockBlack INT,
  IncrementWhite INT,
  IncrementBlack INT,
  IncrementAfterMoveReached INT,
  IncrementAfterMoveReachedAt INT,

  GameId BLOB,

  PRIMARY KEY (Id),
  FOREIGN KEY (GameId) REFERENCES Games(Id)
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
