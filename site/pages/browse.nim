import mysql, strtabs, strutils, 
       database

proc getTitle(): string =
  result = "Hackrod List of Packages"


proc NumCategories(): int =
  discard mysql.query(conn, "SELECT count(id) FROM categories")
  var cursor = mysql.store_result(conn)
  var row = mysql.fetch_row(cursor)
  result = ParseInt( $row[0] )


proc PackagesForCategory(id: int): seq[ tuple[id:int, name:string, synop:string] ] =
  discard mysql.query(conn, "SELECT id,name,synopsis FROM packages WHERE category_id=$#"%[$id])
  var cursor = mysql.store_result(conn)
  result = @[]
  var row = mysql.fetch_row(cursor)
  while row != nil:
    var name, synop: string = ""
    if row[1] != nil: name = $row[1]
    if row[2] != nil: synop = $row[2]
    result.add(  (ParseInt($row[0]), name, synop) )
    row = mysql.fetch_row(cursor)


proc NumCategoriesWithPackageCount(): seq[tuple[id:int, name:string, pkgcount:int]] =
  var Q = """select categories.id,categories.name,count(packages.category_id) as pkgcount
             from categories
             join packages 
               ON packages.category_id=categories.id
             group by packages.category_id"""
  discard mysql.query(conn, Q)
  var cursor = mysql.store_result(conn)

  result = @[]
  var row = mysql.fetch_row(cursor)
  while row != nil:
    result.add(  (ParseInt($row[0]), $row[1], ParseInt($row[2])) )
    row = mysql.fetch_row(cursor)


proc CategoriesString(): string = 
  var cats = NumCategoriesWithPackageCount()
  result = ""
  for i in low(cats)..high(cats):
    result = result & cats[i].name & " (" & $cats[i].pkgcount & ")"
    if i<high(cats): 
      result = result & ", "
    else:
      result = result & " "


include "site/templates/header.tmpl"
include "site/templates/footer.tmpl"
include "site/templates/browse.tmpl"

