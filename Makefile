include ./config.mk

.PHONY: all
all: server client

.PHONY: sevrer
server:
	make -C ./server

.PHONY: client
client:
	make -C ./client

.PHONY: clean
clean:
	make -C ./server clean
	make -C ./client clean