debug:
	shards build -p -t --threads=$(shell nproc --all)

release:
	shards build -p -t -v --release --production --no-debug --mcpu=native --threads=$(shell nproc --all)
