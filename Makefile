

NIM = nimrod
NIMOPT = --path:config --path:src/server --path:site/pages


all: server

server: server.nim
	${NIM} ${NIMOPT} compile server.nim


clean:
	rm -rf nimcache server
        
.PHONY : clean
