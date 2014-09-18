fs = require 'fs'
us = require 'underscore'

pickCount = 3
n = 12

bMap = (arr)->
	map = {}
	for e in arr
		map[e] = false
	map

fs.readFile 'test2.json', (err,data)->
	orderPairSet = JSON.parse data.toString()
	ref = us.map orderPairSet, (e)->
		JSON.parse e
	pairUsed = bMap orderPairSet
	schedules = for k in [1..pickCount]
					elementUsed = bMap [1..n]
					picked = []
					i = 0
					while picked.length < n/2
						currentPair = ref[i]
						currentPairStr = orderPairSet[i]
						if !pairUsed[currentPairStr] && !elementUsed[currentPair[0]] && !elementUsed[currentPair[1]]
							pairUsed[currentPairStr] = true
							elementUsed[currentPair[0]] = true
							elementUsed[currentPair[1]] = true
							console.log(currentPair);
							picked.push currentPair
						i++
						# if i==orderPairSet.length && picked.length<n/2
						# 	console.log picked,'bad'
						# 	picked = []
						# 	i = us.random(0,orderPairSet.length-1)
						# 	pairUsed = JSON.parse(JSON.stringify(pairUsed_g))
					console.log 'good'
					picked
