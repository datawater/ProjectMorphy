require "kemal"
require "sqlite3"

require "./tournament.cr"

REGISTER_BOARD_SQL = "INSERT INTO Boards (Id) VALUES (?)"

def register_board(tournamentId : UInt64, boardId : String)
  db = Tournament.get_tournament_from_id tournamentId

  db.exec REGISTER_BOARD_SQL, boardId
end

post "/register_board" do |env|
  boardId = env.params.body["UUID"]?.as?(String)
  tournamentId = env.request.cookies["TOURNAMENT_TOKEN"]?

  if boardId == nil
    env.response.status_code = 400
    next "Post Request field \"UUID\" is required."
  end

  if tournamentId == nil
    env.response.status_code = 400
    next "Tournament Token is required!"
  end

  boardId = boardId.as(String)
  tournamentId = tournamentId.as(HTTP::Cookie).value.to_u64

  register_board tournamentId, boardId

  cookie = HTTP::Cookie.new(
    name: "BOARD_TOKEN",
    value: boardId,
    http_only: true,
    secure: true
  )

  env.response.cookies << cookie
end
