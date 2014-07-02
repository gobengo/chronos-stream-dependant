.PHONY: all build

all: build

build: node_modules

# dev JS
dist: build
	mkdir -p dist
	./node_modules/.bin/browserify index.js -r ./index.js:chronos-stream-dependant > dist/chronos-stream-dependant.js

server: build
	./node_modules/.bin/http-server .

# if package.json changes, install
node_modules: package.json
	npm install
	cd node_modules/through2-dependant && npm install
	touch $@

clean:
	rm -rf node_modules dist

