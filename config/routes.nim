import strtabs,
  index,
  recent
 
 
type
  TCallback* = proc (x: PStringTable): string

 

proc buildNameList*(): seq[string] = 
  result = @[]
  result.add("/")
  result.add("/index")
  result.add("/recent")

proc buildProcList*(): seq[TCallback] = 
  result = @[]
  result.add(index.render)
  result.add(index.render)
  result.add(recent.render)
