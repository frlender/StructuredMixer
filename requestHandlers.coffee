us = require 'underscore'
fs = require 'fs'

members = fs.readFileSync 'data/records.json'
members = JSON.parse members.toString()

# record user choices.
saveInfo = ()->
	fs.writeFile 'data/records.json',JSON.stringify(members)
setInterval(saveInfo,300000);
## experimental data
# members = 
# 	"Michael Phelps":
# 		idx: 1
# 		pick: []
# 	"Liu Xiang":
# 		idx: 2
# 		pick: []
# 	"Yao Ming":
# 		idx: 3
# 		pick: []
# 	"Allyson Felix":
# 		idx: 4
# 		pick: []
# 	"Shawn Johnson":
# 		idx: 5
# 		pick: []
# 	"Roman Sebrle":
# 		idx: 6
# 		pick: []
# 	"Guo Jingjing":
# 		idx: 7
# 		pick: []
# 	"Tyson Gay":
# 		idx: 8
# 		pick: []
# 	"Asafa Powell":
# 		idx: 9
# 		pick: []
# 	"Usain Bolt":
# 		idx: 10
# 		pick: []
# 	"James Aron":
# 		idx: 11
# 		pick: []
# 	"Peter Rice":
# 		idx: 12
# 		pick: []

pickCount = 3;
n = Object.keys(members).length
combinations = []
for i in [1..n-1]
	for j in [i+1..n]
		if j <= n
			combinations.push(JSON.stringify([i,j]))

idx2name = {}
for key,val of members
	idx2name[val.idx] = key


bMap = (arr)->
	map = {}
	for e in arr
		map[e] = false
	map

computeSchedule = ()->
	# only use members,n,pickCount globals
	pairs = []
	for person, val of members
		if val.pick.length > 0
			pairs = pairs.concat ([val.idx,members[pickPerson].idx] for pickPerson in val.pick)


	pairSortStr = us.map pairs, (e)->
		JSON.stringify us.sortBy e,us.identity

	pairCount = us.countBy(pairSortStr)

	mutuals = []
	for pair, count of pairCount
		if count > 1
			mutuals.push pair

	pairSet = us.keys pairCount
	unilaterals = us.difference pairSet, mutuals

	nones = us.difference combinations, pairSet
	orderPairSet = us.shuffle(mutuals).concat(us.shuffle(unilaterals)).concat(us.shuffle(nones))

	ref = us.map orderPairSet, (e)->
		JSON.parse e

	sectionPairs = (orderPairSet,ref,pairUsed)->
		elementUsed = bMap [1..n]
		picked = []
		i = 0
		while picked.length < n/2 && i<orderPairSet.length
			currentPair = ref[i]
			currentPairStr = orderPairSet[i]
			if !pairUsed[currentPairStr] && !elementUsed[currentPair[0]] && !elementUsed[currentPair[1]]
				pairUsed[currentPairStr] = true
				elementUsed[currentPair[0]] = true
				elementUsed[currentPair[1]] = true
				picked.push currentPair
			i++

		if picked.length<n/2
			return false
		else
			return {pairUsed:pairUsed,picked:picked}

	schedules = []
	pairUsed = bMap orderPairSet
	# shuffleStatus = 'none'
	while schedules.length < pickCount
		result = sectionPairs orderPairSet,ref,us.clone(pairUsed)
		if result==false
			orderPairSet = us.shuffle(mutuals).concat(us.shuffle(unilaterals)).concat(us.shuffle(nones))
			ref = us.map orderPairSet, (e)->
				return JSON.parse(e)
		else
			schedules.push result.picked
			pairUsed = result.pairUsed

	schedules = for section in schedules
					for pair in section
						[idx2name[pair[0]],idx2name[pair[1]]]
	schedules


schedule = computeSchedule()

exports.initialize = (req,res)->
	pickedCount = 0
	names = for person, val of members
				if val.pick.length > 0
					pickedCount++
				person
	if us.contains(names,'null')
		totalCount = n-1
	names = us.filter names, (e)->
		e!='null'
	res.send {names:names,pickedCount:pickedCount,totalCount:totalCount}



exports.submitPreference = (req,res)->
	source = req.param 'source'
	target = JSON.parse req.param 'target'
	previousPick = members[source].pick
	if us.intersection(previousPick,target).length != pickCount
		members[source].pick = target
		schedule = computeSchedule()
	res.send 'done'

exports.getSchedule = (req,res)->
	filteredSchedule = us.map schedule,(session)->
		us.filter session,(pair)->
			!us.contains(pair,'null')
	res.send filteredSchedule

