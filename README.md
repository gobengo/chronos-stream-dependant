# browserify bug?

Thanks for reading this. This is a reduced test case of a weird bug I cannot understand when using browserify and through2.

## Reproduce

* clone this repo
* `make dist` - Will
    * npm install this project and the bundled `through2-dependant` package, which depends on through2@0.5.1
    * browserify this project (index.js entrypoint)
* `make server` to serve this directory over HTTP. Visit /index.html
* You should see 'worked!' and no uncaught exceptions in the console
* Now go to ./node_modules/through2-dependant/index.js and uncomment line 7
* run `make dist` again to re-browserify
* Refresh the page.
* (!) There will be an uncaught exception when trying to construct a chronos-stream-fake.

## wtf?

I am new to browserify (and enjoying it), but I can't diagnose this.

I think it may have something to do with [these instanceof checks](https://github.com/isaacs/readable-stream/blob/v1.0.27-1/lib/_stream_writable.js#L127) failing.

So when I do

```javascript
function ResponseToObjects(opts) {
    opts = opts || {};
    opts.objectMode = true;
    Transform.call(this, opts);
}
```

That `Transform.call` does not actually add state to `this`, it just returns a `new` Transform that is immediately GCd. I may be confusing this with another oddity I saw in this 5 hour debugging session... oy.

## What fixes?

In ./node_modules/through2-browser, I've included a version of through2 that makes this work for me. The only differences are

1. through2.js uses

    ```javascript
    var Transform = require('readable-stream').Transform;
    ```

    instead of

    ```javascript
    var Transform = require('readable-stream/transform');
    ```

2. package.json has this added

    ```json
    "browser": {
        "readable-stream": "stream-browserify"
    },
    ```
