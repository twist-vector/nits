import 
  sockets, os, strutils
  

#####################
# These should be added to scgi module?
#

proc writeStatusOk*(c: TSocket, Content: string = "text/html") = 
  ## sends the following string to the socket `c`::
  ##
  ##   Status: 200 OK\r\LContent-Type: text/html\r\L\r\L
  ##
  ## You should send this before sending your HTML page, for example.
  c.send("Status: 200 OK\r\L" & 
         "Content-Type: $#\r\L\r\L"%[Content])


proc writeStatusFileNotFound*(c: TSocket, Content: string = "text/html") = 
  ## sends the following string to the socket `c`::
  ##
  ##   Status: 404 OK\r\L\r\L
  ##
  ## You should send this before sending your HTML page, for example.
  c.send("Status: 404 OK\r\L" & 
         "Content-Type: $#\r\L\r\L"%[Content])

#####################

