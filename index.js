var ThingThatDependsOnThrough2 = require('through2-dependant');
var ChronosStream = require('chronos-stream-fake');

module.exports = function test(opts) {
    var cs = new ChronosStream('topic');

    cs.on('error', function (err) {
      console.log('chronos err', err);
    });

    cs.on('data', function (data) {
      console.log('chronos data', data);
    });
};
