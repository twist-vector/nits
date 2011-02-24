#
#
#            Nimrod in the Sky
#
# This is the "Nimrod in the Sky" web application framework and
# Hackrod site/database.  At present (early 2011) it is _very_ rough,
# but it does seem to run.
#

import 
  scgi, sockets, strutils, parsecfg,
  os, osproc, strtabs, streams,
  routes, statuscodes, database
  


var mimeTypes      = newStringTable(modeCaseInsensitive)
var databaseParams = newStringTable(modeCaseInsensitive)
var pathParams     = newStringTable(modeCaseInsensitive)
var doingMimetypes, doingRoots, doingDatabase: bool = false

var f = newFileStream("config/server.cfg", fmRead)
if f != nil:
  var p: TCfgParser
  open(p, f, "config/server.cfg")
  while true:
    var e = next(p)
    case e.kind
    of cfgEof:
      break
      
    of cfgSectionStart:
      case e.section
      of "Mimetypes":
        doingMimetypes = true
        doingRoots     = false
        doingDatabase  = false
      of "Roots":
        doingMimetypes = false
        doingRoots     = true
        doingDatabase  = false
      of "Database":
        doingMimetypes = false
        doingRoots     = false
        doingDatabase  = true
      
    of cfgKeyValuePair:
      if doingMimetypes:
        mimeTypes[e.key] = e.value
      elif doingRoots:
        pathParams[e.key] = e.value
      elif doingDatabase:
        databaseParams[e.key] = e.value
  
    of cfgOption:
      echo("command: " & e.key & ": " & e.value)
    of cfgError:
      echo(e.msg)
    
  close(p)
else:
  echo("cannot open config/server.cfg")
  quit()



# Call the routes functions that build the PATH_INFO names
# we'll be supporting and the "render" functions to call when we get
# the request.  Here nameList holds the names of all the paths we'll
# respond to, procList holds proc pointers to call when we get the
# request (hash table, I know).
var nameList = routes.buildNameList()
var procList = routes.buildProcList()



# Set up the database connection
database.setup(databaseParams["host"], databaseParams["username"], 
               databaseParams["password"], databaseParams["database"])



#
# This gets called whenever the SCGI server gets a request...
#
proc handleRequest(client: TSocket, input: string, 
                   headers: PStringTable): bool {.procvar.} =

  # PATH_INFO holds the request name.  We'll use these to look 
  # up the appropriate renderer.
  #for k,v in pairs(headers):
  #  echo( "$#: $#"%[k,v] )

  # First check if we have a static file to send.  If so, send it.
  # Note we need to strip off the leading "/" which may not be the same 
  # as our OS file separator.
  var fileName = JoinPath(pathParams["docroot"], headers["PATH_INFO"].copy(1))
  var fileData = splitFile(fileName)
  if existsFile(fileName):
    # Must be a static file.  We'll read it in and send it on.  Content type
    # will be text/plain unless we have a different mapping (see config/server.cfg)
    var content = readFile(fileName)
    var contentType = "text/plain"
    if mimeTypes.hasKey(fileData.ext):
      contentType = mimeTypes[fileData.ext]
    client.writeStatusOk(contentType)
    client.send(content)
    
  else:
    # Not a static file, see if we have a renderer.
    var path = headers["PATH_INFO"]
    if nameList.contains(path):
      # We have a handler for this request.  Get it's location in the array and
      # the proc to call (this will be easier w/ a hash table)
      
      # Parse the query string to build the hash table of query parameters.  This we'll
      # pass to the render routine.
      var queryStrings = newStringTable(modeCaseInsensitive)
      for v in items(split(headers["QUERY_STRING"], '&')):
        var kv = split(v,'=')
        queryStrings[kv[0]] = kv[1]
      
      var loc = nameList.find(path)
      var html = procList[loc](queryStrings)

      # Send the appropriate header and the rendered page.
      client.writeStatusOk()
      client.send(html)
    else:
      # Nope, no handler...  Send a 404.
      var content = readFile( JoinPath(pathParams["templatepath"],"404.tmpl") )
      client.writeStatusFileNotFound()
      client.send(content)

  return false # do not stop processing

run(handleRequest)
