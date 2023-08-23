extends Node

const SAVE_DIR = "user://saves/"

var currentLevel = 1
var cheat_code: Array
var godGun = false
var sceneAfterNaming = ""

var playerName = ""

var save_path = SAVE_DIR + "save.dat"

var save = [
	{
#		1 : [
#			{ 0: "speed" : 0 },
#			{ 1: "sharp" : 0 },
#			{ 2: "bestTime" : "99:99" },
#			{ 3: "mins" : 99 },
#			{ 4: "secs" : 99 },
#			{ 5: "mils" : 99 },
#			{ 6: "bulletsFired" : 99 },
#			{ 7: "unlockedLevel" : true },
#
#		],
		1 : [0,0,0,99,99,99,99,true],
		2 : [0,0,0,99,99,99,99,false],
		3 : [0,0,0,99,99,99,99,false],
		4 : [0,0,0,99,99,99,99,false],
		5 : [0,0,0,99,99,99,99,false],
		6 : [0,0,0,99,99,99,99,false],
		7 : [0,0,0,99,99,99,99,false],
		8 : [0,0,0,99,99,99,99,false],
		9 : [0,0,0,99,99,99,99,false]
	},
	{
		"playerName" : ""
	}
]


func _ready():
	
	var f=File.new()
	f.open('res://apiKey.env',File.READ)
	var apiKey=f.get_line()
	f.close()
	
	SilentWolf.configure({
		"api_key": apiKey,
		"game_id": "sixbit",
		"game_version": "1.4",
		"log_level": 0
	})
	
	loadSave()
	
	# for example, "cheat1" and "cheat2" for codes
	cheat_code.resize(2)
	cheat_code[0] = [int(0), KEY_U, KEY_N, KEY_L, KEY_O, KEY_C, KEY_K]
	cheat_code[1] = [int(0), KEY_G, KEY_O, KEY_D, KEY_G, KEY_U, KEY_N]


func saveScore(currentLevel, levelSpeed, levelSharp, levelTime, levelTimeMins, levelTimeSecs, levelTimeMils, bulletsFired, timeToFinishAsDecimal):
	
	# Get current saved results
	var bestCurrentLevelSpeed = save[0][currentLevel][0]
	var bestCurrentLevelSharp = save[0][currentLevel][1]
	var bestCurrentTimer = save[0][currentLevel][2]
	var bestCurrentMins = save[0][currentLevel][3]
	var bestCurrentSecs = save[0][currentLevel][4]
	var bestCurrentMils = save[0][currentLevel][5]
	var bestBulletsFired = save[0][currentLevel][6]
	
	
	# Change Time if better
	if (bestCurrentMins > levelTimeMins) || (bestCurrentMins == levelTimeMins && bestCurrentSecs > levelTimeSecs) || (bestCurrentMins == levelTimeMins && bestCurrentSecs == levelTimeSecs && bestCurrentMils > levelTimeMils):
		save[0][currentLevel][2] = levelTime
		save[0][currentLevel][3] = levelTimeMins
		save[0][currentLevel][4] = levelTimeSecs
		save[0][currentLevel][5] = levelTimeMils
		
		if Global.playerName != "" && currentLevel != 1:
			# Silent wolf ne fait que des leaderboard avec le plus gros score
			# nous on veut faire le plus petit score, donc j'inverse le temps
			# si un joueur fait 1s et l'autre 2s
			# celui qui a fait 1s sera à 9999 et l'autre à 9998 donc il est meilleur
			# il faut que je pense à inverser aussi quand je récupère les score par contre
			var invTime = 10000 - timeToFinishAsDecimal
			SilentWolf.Scores.persist_score(Global.playerName, invTime, "level" + str(currentLevel))

	
	# Change speed star if better
	if bestCurrentLevelSpeed < levelSpeed:
		save[0][currentLevel][0] = levelSpeed
	
	# Change sharp star if better	
	if bestCurrentLevelSharp < levelSharp:
		save[0][currentLevel][1] = levelSharp
		
	# Change the number of bullets fired to finish the level if better		
	if bestBulletsFired > bulletsFired:
		save[0][currentLevel][6] = bulletsFired

	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "dontcheat")
	if error == OK:
		file.store_var(save)
		file.close()
	
func saveGame():
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "dontcheat")
	if error == OK:
		file.store_var(save)
		file.close()

func loadSave():
	var file = File.new()
	if file.file_exists(save_path):
		var error = file.open_encrypted_with_pass(save_path, File.READ, "dontcheat")
		if error == OK:
			var savedfile = file.get_var()
			file.close()
#			print(savedfile)
			save = savedfile

func resetSave():
	save = [
		{
			1 : [0,0,0,99,99,99,99,true],
			2 : [0,0,0,99,99,99,99,false],
			3 : [0,0,0,99,99,99,99,false],
			4 : [0,0,0,99,99,99,99,false],
			5 : [0,0,0,99,99,99,99,false],
			6 : [0,0,0,99,99,99,99,false],
			7 : [0,0,0,99,99,99,99,false],
			8 : [0,0,0,99,99,99,99,false],
			9 : [0,0,0,99,99,99,99,false]
		},
		{
			"playerName" : ""
		}
	]
	
	var dir = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var file = File.new()
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "dontcheat")
	if error == OK:
		file.store_var(save)
		file.close()

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

