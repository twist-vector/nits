import mysql, strtabs, strutils, 
       database


proc toStr(str: Cstring): string = 
  if str == nil:
    result = ""
  else:
    result = $str


proc getTitle(): string =
  result = "Hackrod Package Details"


proc GetPackageDetails(id: int): PStringTable = 
  result = newStringTable(modeCaseInsensitive)
  
  discard mysql.query(conn, "SELECT * FROM packages WHERE id=$#"%[$id])
  var cursor = mysql.store_result(conn)
  var row = mysql.fetch_row(cursor)
  if row != nil:
    result["id"]            = toStr(row[0])
    result["name"]          = toStr(row[1])
    result["version"]       = toStr(row[2])
    result["pkgfilename"]   = toStr(row[3])
    result["babelfilename"] = toStr(row[4])
    result["synopsis"]      = toStr(row[5])
    result["description"]   = toStr(row[6])
    result["author"]        = toStr(row[7])
    result["license"]       = toStr(row[8])
    result["copyright"]     = toStr(row[9])
    result["maintainer"]    = toStr(row[10])
    result["category"]      = toStr(row[11])
    result["depends"]       = toStr(row[12])
    result["exposes"]       = toStr(row[13])
    result["created_at"]    = toStr(row[14])



include "site/templates/header.tmpl"
include "site/templates/footer.tmpl"
include "site/templates/show.tmpl"

