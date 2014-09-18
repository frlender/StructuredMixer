var us = require('underscore');

pickCount = 3;
n = 12;
var generator = function(n){
	var pairs = [];
	us.range(1,n+1).forEach(function(e){
		var currentMatches = [];
		while(currentMatches.length<pickCount){
			var randMatch = us.random(1,n);
			if(randMatch!=e && !us.contains(currentMatches,randMatch)){
				currentMatches.push(randMatch);
			}
		}
		var currentPair = us.map(currentMatches,function(el){
			return [e,el];
		});
		pairs = pairs.concat(currentPair);
	});
	return pairs;
}

var pairs = generator(12);

fs.writeFile('pairs.json',JSON.stringify(pairs),function(err){});

var pairsSortStr = us.map(pairs,function(e){
	return JSON.stringify(us.sortBy(e));
});

var pairCount = us.countBy(pairsSortStr);

var mutuals = [];
us.each(pairCount,function(val,key){
	if(val>1) mutuals.push(key);
});

var pairsSet = us.keys(pairCount);
var unilaterals = us.difference(pairsSet,mutuals);

var combinations = [];
for(var i=1;i<n+1;i++){
	for(var j=i+1;j<n+1;j++){
		combinations.push(JSON.stringify([i,j]));
	}
}

var nones = us.difference(combinations,pairsSet);

var orderPairsSet = mutuals.concat(unilaterals).concat(nones);

var ref = us.map(orderPairsSet,function(e){
	return JSON.parse(e);
});

// create schedule

var bMap = function(arr){
	var map = {};
	arr.forEach(function(e){
		map[e] = false;
	});
	return map;
};

var pairUsed = bMap(orderPairsSet);
var schedules = us.map(us.range(pickCount),function(){
	var elementUsed = bMap(us.range(1,n+1));
	var picked = [];
	var i = 0;
	while(picked.length<n/2){
		var currentPair = ref[i];
		var currentPairStr = orderPairsSet[i];
		if(!pairUsed[currentPairStr] && !elementUsed[currentPair[0]] && !elementUsed[currentPair[1]]){
			pairUsed[currentPairStr] = true;
			elementUsed[currentPair[0]] = true;
			elementUsed[currentPair[1]] = true;
			picked.push(currentPair);
		};
		i++;
	};
	return picked;
});