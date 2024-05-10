require "sqlite3"
require "kemal"
require "uri"

INITIALIZE_SQL_STRING =
"
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
"

module Tournament
  extend self

  TOURNAMENTS = Hash(UInt64, DB::Database).new

  class Tournament
    def initialize(database : DB, name : String)
      @database = database
      @name = name
    end
  
    def database
      @database
    end
  end
  
  def register_tournament(id : UInt64)
    if TOURNAMENTS[id]? != nil 
      return 1
    end

    DB.open "sqlite3://tournament#{URI.encode_path_segment "#{TOURNAMENTS.size}-#{Time.utc.to_rfc3339}"}.sqlite?mode=memory&cache=shared" do |db|
      db.exec INITIALIZE_SQL_STRING
    
      TOURNAMENTS[id] = db
    end

    return 0
  end

  def get_tournament_from_id(id : UInt64)
    TOURNAMENTS[id]
  end
end

post "/new_tournament" do |env|
  id = env.params.body["name"].hash
  result = Tournament.register_tournament id
  
  if result == 1
    env.response.status_code = 409
    next "A tournament with this name already exists"
  end

  cookie = HTTP::Cookie.new(
    name: "TOURNAMENT_TOKEN",
    value: id.to_s,
    http_only: true,
    secure: true
  )

  env.response.cookies << cookie
end
