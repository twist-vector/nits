
import
  mysql, strutils


proc setup*(host, username, password, database: string): PMySQL =
  result = init(nil)
  if real_connect(result, host, username, password, database, 0, nil, 0) == nil:
    var e: ref EOS
    new(e)
    e.msg = "Failed to connect to database"
    raise e

