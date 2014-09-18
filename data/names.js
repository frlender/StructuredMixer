var fs = require('fs');
var us = require('underscore');

fs.readFile('names',function(err,res){
	console.log(res);
	var names = res.toString().split('\n');
	if(names[names.length-1]=='') names = names.slice(0,names.length-1);
	var records = {};
	names.forEach(function(e,i){
		records[e] = {};
		records[e].idx = i+1;
		records[e].pick = [];
	});
	if(names.length%2!=0){
		records['null'] = {};
		records['null'].idx = names.length+1;
		records['null'].pick = [];
	}
	fs.writeFile('records.json',JSON.stringify(records),function(err){});
});