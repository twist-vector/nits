import strtabs,
  index,
  recent,
  browse,
  upload,
  signin,
  show
 
 
type
  TCallback* = proc (x: PStringTable): string

 

proc buildNameList*(): seq[string] = 
  result = @[]
  result.add("/")
  result.add("/index")
  result.add("/recent")
  result.add("/browse")
  result.add("/upload")
  result.add("/signin")
  result.add("/show")

proc buildProcList*(): seq[TCallback] = 
  result = @[]
  result.add(index.render)
  result.add(index.render)
  result.add(recent.render)
  result.add(browse.render)
  result.add(upload.render)
  result.add(signin.render)
  result.add(show.render)
