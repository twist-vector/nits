
import
  mysql, strutils


var conn*: PMySQL

proc setup*(host, username, password, database: string) =
  conn = init(nil)
  if real_connect(conn, host, username, password, database, 0, nil, 0) == nil:
    var e: ref EOS
    new(e)
    e.msg = "Failed to connect to database"
    raise e




