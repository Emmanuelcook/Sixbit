extends Node

const SAVE_DIR = "user://saves/"

#Settings
var musicVol = 0
var sfxVol = 0
var maxTrauma = .6

#BIOME
enum Biomes {DESERT, JUNGLE}
var _biome : int = Biomes.DESERT

var currentLevel = 1
var cheat_code: Array
var godGun = false
var sceneAfterNaming = ""

var needToReloadScore = true

var playerName = ""



#SPEEDRUN
var speedRunActive = false
var SRtimeSpeedRun = 0
var SRbullet = 0
# Time for the level
var SRtimeToFinish = 0
var SRtimerState = false
var SRtime_passed = '00:00:00'
var SRmils = 1
var SRsecs = 0
var SRmins = 0
var speedRunFinished = false
var fullResetInput = 0

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
#			{ 8: "score" : 9999.61858 },
#
#		],
		1 : [0,0,"99",99,99,99,99,true, 0],
		2 : [0,0,"99",99,99,99,99,false, 0],
		3 : [0,0,"99",99,99,99,99,false, 0],
		4 : [0,0,"99",99,99,99,99,false, 0],
		5 : [0,0,"99",99,99,99,99,false, 0],
		6 : [0,0,"99",99,99,99,99,false, 0],
		7 : [0,0,"99",99,99,99,99,false, 0],
		8 : [0,0,"99",99,99,99,99,false, 0],
		9 : [0,0,"99",99,99,99,99,false, 0],
		11 : [0,0,"99",99,99,99,99,true, 0],
		12 : [0,0,"99",99,99,99,99,false, 0],
		13 : [0,0,"99",99,99,99,99,false, 0],
		14 : [0,0,"99",99,99,99,99,false, 0],
		15 : [0,0,"99",99,99,99,99,false, 0],
		16 : [0,0,"99",99,99,99,99,false, 0],
		17 : [0,0,"99",99,99,99,99,false, 0],
		18 : [0,0,"99",99,99,99,99,false, 0],
		19 : [0,0,"99",99,99,99,99,false, 0]
	},
	{
		"playerName" : "",
		"gameVersion" : "1.4"
	},
	{
		#STATS
		"fullRunTime" : 0,
		"speedRunTime" : 0,		
		"allTimebulletsShot" : 0,
		"AllTimetargetHits" : 0,
		"accuracy" : 0,
		
	}
]

func resetSave():
	save = [
		{
			1 : [0,0,"99",99,99,99,99,true, 0],
			2 : [0,0,"99",99,99,99,99,false, 0],
			3 : [0,0,"99",99,99,99,99,false, 0],
			4 : [0,0,"99",99,99,99,99,false, 0],
			5 : [0,0,"99",99,99,99,99,false, 0],
			6 : [0,0,"99",99,99,99,99,false, 0],
			7 : [0,0,"99",99,99,99,99,false, 0],
			8 : [0,0,"99",99,99,99,99,false, 0],
			9 : [0,0,"99",99,99,99,99,false, 0],
			11 : [0,0,"99",99,99,99,99,true, 0],
			12 : [0,0,"99",99,99,99,99,false, 0],
			13 : [0,0,"99",99,99,99,99,false, 0],
			14 : [0,0,"99",99,99,99,99,false, 0],
			15 : [0,0,"99",99,99,99,99,false, 0],
			16 : [0,0,"99",99,99,99,99,false, 0],
			17 : [0,0,"99",99,99,99,99,false, 0],
			18 : [0,0,"99",99,99,99,99,false, 0],
			19 : [0,0,"99",99,99,99,99,false, 0]
		},
		{
			"playerName" : "",
			"gameVersion" : "1.4"
		},
		{
			#STATS
			"fullRunTime" : 0,
			"speedRunTime" : 0,		
			"allTimebulletsShot" : 0,
			"AllTimetargetHits" : 0,
			"accuracy" : 0,
			
		}
	]
	
	saveGame()
	

func _ready():

	# CONFIGURE SILENT WOLF
	var f=File.new()
	f.open('res://apiKey.env',File.READ)
	var apiKey=f.get_line()
	f.close()
	
	SilentWolf.configure({
		"api_key": apiKey,
		"game_id": "sixbit",
		"game_version": "1.4",
		"log_level": 1
	})
	
	
	loadSave()
	
	


	# FIX FOR THOSE WHO DIDNT PLAY SINCE 1.3
	if save.size() < 3:
		resetSave()
		

	
	if save[0].size() < 11:
		print('remerged')
		var addSave = [
			{
				11 : [0,0,"99",99,99,99,99,true, 0],
				12 : [0,0,"99",99,99,99,99,false, 0],
				13 : [0,0,"99",99,99,99,99,false, 0],
				14 : [0,0,"99",99,99,99,99,false, 0],
				15 : [0,0,"99",99,99,99,99,false, 0],
				16 : [0,0,"99",99,99,99,99,false, 0],
				17 : [0,0,"99",99,99,99,99,false, 0],
				18 : [0,0,"99",99,99,99,99,false, 0],
				19 : [0,0,"99",99,99,99,99,false, 0]
			}
		]
		save[0].merge(addSave[0])
	

	print(save)

#	print(save)
	# for example, "cheat1" and "cheat2" for codes
	cheat_code.resize(3)
	cheat_code[0] = [int(0), KEY_U, KEY_N, KEY_L, KEY_O, KEY_C, KEY_K]
	cheat_code[1] = [int(0), KEY_G, KEY_O, KEY_D, KEY_G, KEY_U, KEY_N]
	cheat_code[2] = [int(0), KEY_J, KEY_U, KEY_N, KEY_G, KEY_L, KEY_E]

	

func saveScore(currentLevel, levelSpeed, levelSharp, levelTime, levelTimeMins, levelTimeSecs, levelTimeMils, bulletsFired, timeToFinish):
	
	var score = 10000 - timeToFinish
#	print("PN: " + str(Global.playerName))
	if Global.playerName != "" && currentLevel != 1:
		SilentWolf.Scores.persist_score(Global.playerName, score, "level" + str(currentLevel))

	
	# Get current saved results
	var bestCurrentLevelSpeed = save[0][currentLevel][0]
	var bestCurrentLevelSharp = save[0][currentLevel][1]
	var bestCurrentTimer = save[0][currentLevel][2]
	var bestCurrentMins = save[0][currentLevel][3]
	var bestCurrentSecs = save[0][currentLevel][4]
	var bestCurrentMils = save[0][currentLevel][5]
	var bestBulletsFired = save[0][currentLevel][6]
	var bestScore = save[0][currentLevel][8]
	
	
	# Change Time if better
	if score > bestScore:
		save[0][currentLevel][2] = levelTime
		save[0][currentLevel][3] = levelTimeMins
		save[0][currentLevel][4] = levelTimeSecs
		save[0][currentLevel][5] = levelTimeMils
		save[0][currentLevel][8] = score
	
		
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
			save[0][1][7] = true
			save[0][2][7] = true
			save[0][3][7] = true
			save[0][4][7] = true
			save[0][5][7] = true
			save[0][6][7] = true
			save[0][7][7] = true
			save[0][8][7] = true
			save[0][9][7] = true
			GlobalScene.playSound('unlocked')
			
		1:  # "CHEAT2"
			if godGun:
				godGun = false
			else:
				if !speedRunActive:
					godGun = true
		2:  # "CHEAT3"
			GlobalScene.playSound('monkey')
			_biome = Biomes.JUNGLE
			get_tree().change_scene("res://Levels/Jungle/Level11.tscn")

# STATS

func saveFullTimeRun():
	var fullScoreTime
	
	if save[0][9][8] != 0:
		var fullScoreTimeInv = save[0][1][8] + save[0][2][8] + save[0][3][8] + save[0][4][8] + save[0][5][8] + save[0][6][8] + save[0][7][8] + save[0][8][8] + save[0][9][8]
		fullScoreTime = 90000 - fullScoreTimeInv
		if Global.playerName != "":
			SilentWolf.Scores.persist_score(Global.playerName, fullScoreTimeInv, "desert")
		save[2]["fullRunTime"] = fullScoreTime
		
	saveGame()


func saveAllTimeBulletsFired(bulletNumberToAdd):
	save[2]["allTimebulletsShot"] += bulletNumberToAdd
	saveGame()
	
func saveAllTimeTargets(targetNumberToAdd):
	save[2]["AllTimetargetHits"] += targetNumberToAdd
	saveGame()

func updateSRtimer(delta):
	# update the timer if it's on
	if SRtimerState :
		SRtimeToFinish += delta
		SRmils = fmod(SRtimeToFinish,1)*100
		SRsecs = fmod(SRtimeToFinish, 60)
		SRmins = fmod(SRtimeToFinish, 60*60) / 60
		SRtime_passed = "%02d:%02d:%02d" % [SRmins,SRsecs,SRmils]

func resetSR():
	speedRunActive = false
	SRtimeSpeedRun = 0
	SRbullet = 0
	# Time for the level
	SRtimeToFinish = 0
	SRtimerState = false
	SRtime_passed = '00:00:00'
	SRmils = 1
	SRsecs = 0
	SRmins = 0
	
func saveSRTime():
	speedRunFinished = true
	var SRtimeToFinishInv = 100000 - SRtimeToFinish
	SilentWolf.Scores.persist_score(Global.playerName, SRtimeToFinishInv, "speedrun")
	save[2]["speedRunTime"] = SRtimeToFinish

	resetSR()
