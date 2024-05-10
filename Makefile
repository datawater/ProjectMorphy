debug:
	shards build -p -t --threads=$(shell nproc --all)

release:
	shards build -p -t --release --mcpu=native --threads=$(shell nproc --all)
