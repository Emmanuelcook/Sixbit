extends Node

var currentLevel = 1

var save = [
	{
#		1 : [
#			{ "speed" : 0 },
#			{ "sharp" : 0 },
#			{ "bestTime" : "99:99" },
#			{ "secs" : 99 },
#			{ "mils" : 99 },
#			{ "bulletsFired" : 99 },
#			{ "unlockedLevel" : true },
#
#		],
		1 : [0,0,0,99,99,99,true],
		2 : [0,0,0,99,99,99,false],
		3 : [0,0,0,99,99,99,false],
		4 : [0,0,0,99,99,99,false],
		5 : [0,0,0,99,99,99,false],
		6 : [0,0,0,99,99,99,false],
		7 : [0,0,0,99,99,99,false],
		8 : [0,0,0,99,99,99,false],
		9 : [0,0,0,99,99,99,false]
	}
]


func saveScore(currentLevel, levelSpeed, levelSharp, levelTime, levelTimeSecs, levelTimeMils, bulletsFired):
	
	# Get current saved results
	var bestCurrentLevelSpeed = save[0][currentLevel][0]
	var bestCurrentLevelSharp = save[0][currentLevel][1]
	var bestCurrentTimer = save[0][currentLevel][2]
	var bestCurrentSecs = save[0][currentLevel][3]
	var bestCurrentMils = save[0][currentLevel][4]
	var bestBulletsFired = save[0][currentLevel][5]
	
	# Change Time if better
	if (bestCurrentSecs > levelTimeSecs) || (bestCurrentSecs == levelTimeSecs && bestCurrentMils > levelTimeMils):
		save[0][currentLevel][2] = levelTime
		save[0][currentLevel][3] = levelTimeSecs
		save[0][currentLevel][4] = levelTimeMils
	
	# Change speed star if better
	if bestCurrentLevelSpeed < levelSpeed:
		save[0][currentLevel][0] = levelSpeed
	
	# Change sharp star if better	
	if bestCurrentLevelSharp < levelSharp:
		save[0][currentLevel][1] = levelSharp
		
	# Change the number of bullets fired to finish the level if better		
	if bestBulletsFired > bulletsFired:
		save[0][currentLevel][5] = bulletsFired
