phantom.injectJs('html/processing.min.js');

var fs = require('fs');
var system = require('system');

if (system.args.length === 1) {
    console.log('Try to pass some args when invoking this script!');
} else {
    system.args.forEach(function (arg, i) {
    	if(i != 0 && i < 2) {
	    	var file = fs.read(arg);
	    	var code = Processing.compile(file).sourceCode;
	    	console.log(code);
    	}
    });
}

phantom.exit();