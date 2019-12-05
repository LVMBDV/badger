binary:
	shards build

clean:
	rm -rf ./bin

kerning:
	mkdir -p ./res/data
	node scripts/generate-kerning/generate-kerning.js > ./res/data/kerning.dat
