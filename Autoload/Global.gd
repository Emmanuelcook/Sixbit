extends Node

var currentLevel = 1
var cheat_code: Array
var godGun = false


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


func _ready():
	# for example, "cheat1" and "cheat2" for codes
	cheat_code.resize(2)
	cheat_code[0] = [int(0), KEY_U, KEY_N, KEY_L, KEY_O, KEY_C, KEY_K]
	cheat_code[1] = [int(0), KEY_G, KEY_O, KEY_D, KEY_G, KEY_U, KEY_N]

func _unhandled_input(event: InputEvent):
	if event is InputEventKey and event.pressed:
		cheat_entry(event.scancode)

func cheat_entry(key: int):
	var prize := int(-1)
	var keys_entered := int(0)
	var code := int(-1)
	
	# Check for code entry in progress
	for c in range(cheat_code.size()):
		if cheat_code[c][0] > keys_entered:
			keys_entered = cheat_code[c][0]
			code = c
	
	if code >= 0:  # Continue reading code
		if key == cheat_code[code][cheat_code[code][0] + 1]:
			cheat_code[code][0] += 1
		else:
			cheat_code[code][0] = 0
		# If reached end of array, code is complete
		if cheat_code[code][0] == cheat_code[code].size() - 1:
			prize = code
			# Disable re-entry by giving it an impossible check
			cheat_code[code][0] = 0
	else:  # Ready for new code
		for c in range(cheat_code.size()):
			if key == cheat_code[c][cheat_code[c][0] + 1]:
				cheat_code[c][0] += 1
	
	match prize:
		0:  # "CHEAT1"
			save[0][1][6] = true
			save[0][2][6] = true
			save[0][3][6] = true
			save[0][4][6] = true
			save[0][5][6] = true
			save[0][6][6] = true
			save[0][7][6] = true
			save[0][8][6] = true
			save[0][9][6] = true
			GlobalScene.get_node("unlocked").play()
			
		1:  # "CHEAT2"
			if godGun:
				godGun = false
			else:
				godGun = true
				print('e')
			


				

