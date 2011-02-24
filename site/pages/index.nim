import strtabs
 
  
proc getTitle(): string = 
  result = "Hackrod Home"


include "site/templates/header.tmpl"
include "site/templates/footer.tmpl"
include "site/templates/index.tmpl"


