extends Node2D

export var currentLevel = 1
export(int, "Desert", "Jungle") var Biome

var targetIndScene = preload("res://Levels/Props/Targetindicator.tscn")

export var isLastLevel = false
var nextLevel
var levelIsFinished
var godGunWasUsed = false

# Rank to get stars
export var bronzeSpeedStar = 0
export var silverSpeedStar = 0
export var goldSpeedStar = 0
export var bronzeSharpStar = 0
export var silverSharpStar = 0
export var goldSharpStar = 0

# Stars levels
var levelSharp = 0
var levelSpeed = 0

#Bullet fired for the level
var bulletsFired = 0

# Time for the level
var timeToFinish = 0
var timerState = false
var time_passed = '00:00'
var mils = 1
var secs = 0
var mins = 0
var timerMoved = false

# Number of targets in the level / Number of targets shots
var targetNumber = 0
var targetIndex = 0
var targetShot = 0


#Score System
var scoreSavedAtStart = []
var isPlayerInLeaderboard = false
var playerScoreInLeaderboard = 0
var playerScoreInLeaderboardKey = 0
var newTimeToLB = false
var personalPB = false
var highScore = false
var highScoreRank = 99
var betterScoreThanLB = false 

onready var player = $PlayerRoot/Player
onready var endGameScreenNode = $CanvasLayer/EndGameScreen
onready var speedCustomMessage = $CanvasLayer/EndGameScreen/speed_nextOrBest
onready var sharpCustomMessage = $CanvasLayer/EndGameScreen/sharp_nextOrBest

func _ready():
	
	if Biome == 0:
		Global._biome = Global.Biomes.DESERT
		Global.save[2]["actualBiome"] = 0
		GlobalScene.changeAmbianceMusic(0)
		
	if Biome == 1:
		Global._biome = Global.Biomes.JUNGLE
		Global.save[2]["actualBiome"] = 1
		GlobalScene.changeAmbianceMusic(1)
		
	
	Global.saveGame()
	
	$CanvasLayer/EffectTarget.changeBiome()
	
	Global.currentLevel = currentLevel
	
	
	nextLevel = currentLevel + 1 # update nextlevel number
	
	if currentLevel == 9:
		nextLevel = nextLevel + 1
		
	get_tree().paused = false # unpaused if coming from menu
	
	if !isLastLevel:
		if Global.save[0][nextLevel][7] == true:
			endGameScreenNode.unlockNext()
	
	# Display UI but the endscreen game
	$CanvasLayer.visible = true
	endGameScreenNode.visible = false
	
		#Update the number of targets in the level
	for i in $Targets.get_children():
		var targetInd = targetIndScene.instance()
		$CanvasLayer/TargetsIndicators.add_child(targetInd)
		targetInd.global_position = Vector2(43, 482)
		targetInd.global_position.y -= 24 * targetNumber
		targetIndex += 1
		targetNumber += 1
		
	
	if Global.speedRunActive:
		
		Global.godGun = false

		$CanvasLayer/SRTime.visible = true
		endGameScreenNode.get_node("SRRetryButton").visible = true
		endGameScreenNode.get_node("SRStopSR").visible = true
		
		if Global.fullResetInput >= 2:
			Global.saveAllTimeTargets(targetShot)	
			Global.saveAllTimeBulletsFired(bulletsFired - 1)	 # moins 1 pour enlever celle ou on appuie sur le menu c'est tout.
			Global.resetSR()	
			Global.speedRunActive = true
			Global.speedRunFinished = false
			Global.fullResetInput = 0
			get_tree().change_scene("res://Levels/Desert/Level1.tscn")
		
		Global.fullResetInput += 1



	# If a score is saved, display above the gun
	if Global.save[0][currentLevel][4] != 99:
		var bestTime = Global.save[0][currentLevel][2]
		var bestBullets = Global.save[0][currentLevel][6]
		$PlayerRoot/Start2.bbcode_text = '[center]Best time: ' + str(bestTime) + '\n Bullets: ' + str(bestBullets)
		$PlayerRoot/Start2.visible = true
	
	# Get scoreBoard
		
	if currentLevel != 1:
		if Global.needToReloadScore:
			yield(SilentWolf.Scores.get_high_scores(0, "level" + str(currentLevel)), "sw_scores_received")
			Global.needToReloadScore = false
		
		var i = 0

		for score in SilentWolf.Scores.scores:
			scoreSavedAtStart.push_back({"name" : score.player_name, "score" : score.score})
			if score.player_name == Global.playerName:
				isPlayerInLeaderboard = true
				playerScoreInLeaderboard = score.score
				playerScoreInLeaderboardKey = i
			i += 1
		
		i = 0
		
		#UPLOAD LEADERBOARD
		if currentLevel != 1:
			for score in scoreSavedAtStart:
				if i < 5:
					i += 1
					endGameScreenNode.get_node('Name').get_node(str(i)).bbcode_text = str(score.name)

					var invTimeBack = (10000 - score.score)
					var LeaderboardSecs = fmod(invTimeBack, 60)
					var LeaderboardMils = fmod(invTimeBack,1)*100
					var LeaderboardTime = "%02d:%02d" % [LeaderboardSecs,LeaderboardMils]

					endGameScreenNode.get_node('Time').get_node(str(i)).bbcode_text = str(LeaderboardTime)
						
		update_menu()

func update_menu():
	endGameScreenNode.get_node("sharp_results").bbcode_text = "[center]-"
	endGameScreenNode.get_node("speed_results").bbcode_text = "[center]--:--"
	if Global.save[0][currentLevel][2] != "99":
		speedCustomMessage.bbcode_text = "[center]best: " + str(Global.save[0][currentLevel][2])
	else:
		speedCustomMessage.bbcode_text = "[center]No score yet"
	if Global.save[0][currentLevel][6] != 99:
		sharpCustomMessage.bbcode_text = "[center]best: " + str(Global.save[0][currentLevel][6])
	else:
		sharpCustomMessage.bbcode_text = "[center]No score yet"
		
	if Global.save[0][currentLevel][1] > 2:
		$CanvasLayer/EndGameScreen/Gold/Sprite.visible = true
	if Global.save[0][currentLevel][1] > 1:
		$CanvasLayer/EndGameScreen/Silver/Sprite.visible = true
	if Global.save[0][currentLevel][1] > 0:
		$CanvasLayer/EndGameScreen/Bronze/Sprite.visible = true
	if Global.save[0][currentLevel][0] > 2:
		$CanvasLayer/EndGameScreen/Gold2/Sprite.visible = true
	if Global.save[0][currentLevel][0] > 1:
		$CanvasLayer/EndGameScreen/Silver2/Sprite.visible = true
	if Global.save[0][currentLevel][0] > 0:
		$CanvasLayer/EndGameScreen/Bronze2/Sprite.visible = true
	
func _process(delta):
	update()
	if Global.godGun:
		godGunWasUsed = true
	
	# display effect around the gun at the start and makes it rotate
	$PlayerRoot/Start1.global_position = player.global_position
	if $PlayerRoot/Start1.visible:
		$PlayerRoot/Start1.rotation_degrees += 1

	# Can reset the level with R
	# Can reset the level with R
	if Input.is_action_just_pressed("reset"):
		Global.saveAllTimeBulletsFired(bulletsFired)	
		Global.saveAllTimeTargets(targetShot)
			
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("next"):
		if levelIsFinished:
			endGameScreenNode._on_nextLevelButton_pressed()

	# update the timer if it's on
	if timerState :
		timeToFinish += delta
		mils = fmod(timeToFinish,1)*100
		secs = fmod(timeToFinish, 60)
		mins = fmod(timeToFinish, 60*60) / 60

		if mins >= 1:
			time_passed = "%02d:%02d:%02d" % [mins,secs,mils]
			if !timerMoved:
				timerMoved = true
				$CanvasLayer/Timer/gameTime.margin_left -= 60
		else:
			time_passed = "%02d:%02d" % [secs,mils]
	
	if Global.speedRunActive && !Global.speedRunFinished:
		Global.updateSRtimer(delta)
		$CanvasLayer/SRTime.text = Global.SRtime_passed
	
	# display result of the time
	# Anti cheat System
	if mins > 59 && mins < 59.02:
		$CanvasLayer/Timer/gameTime.text = "nope"
	elif mins > 59.02 && mins < 59.04:
		$CanvasLayer/Timer/gameTime.text = "you"
	elif mins > 59.04 && mins < 59.06:
		$CanvasLayer/Timer/gameTime.text = "cant"
	elif mins > 59.06 && mins < 59.08:
		$CanvasLayer/Timer/gameTime.text = "cheat"
	elif mins > 59.1:
		get_tree().reload_current_scene()
	else:
		$CanvasLayer/Timer/gameTime.text = time_passed


func targetShot():
	# check numbers of target shots, 
	# if it matches the number of target in the level. End level.
	targetShot += 1
	targetIndex -= 1
	$CanvasLayer/TargetsIndicators.get_child(targetIndex).gotShot()
		
	
	if targetShot == targetNumber:
		ending_level()

func timer(onOrOff):
	timerState = onOrOff


func ending_level():

	# When level is finished
	levelIsFinished = true
	$PlayerRoot/Anchor.camPaused = true
	
	# stop timer
	timer(false)
	
	if isLastLevel && Global.speedRunActive:
		endGameScreenNode.get_node("LevelsButton").visible = false
		endGameScreenNode.get_node("retryButton").visible = false
		endGameScreenNode.get_node("nextLevelButton").visible = false
		endGameScreenNode.get_node("SRRetryButton").visible = false
		endGameScreenNode.get_node("SRStopSR").visible = false
		
		endGameScreenNode.get_node("SRSubmit").visible = true
		endGameScreenNode.get_node("SRSubmit/score").text = Global.SRtime_passed
		Global.saveSRTime()
		
	# display results
	get_results()
	
		
	if Global.speedRunActive:
		endGameScreenNode.get_node('nextLevelButton').visible = true
		endGameScreenNode.get_node('SRRetryButton').visible = false
	
	# unlock next level in the levels menu
	if !godGunWasUsed:
		
		var timeToFinishForSilentWolf = 10000 - timeToFinish

		unlockNextLevel()
	
		if currentLevel != 1:
			
			# Si on bat son score sur la save actuelle
			if timeToFinishForSilentWolf > Global.save[0][currentLevel][8] :
				#Personal PB && Effect for it
				personalPB = true
				endGameScreenNode.get_node('PBParticles').emitting = true
				
				# si le joueur etait inscirt au leaderboard
				if isPlayerInLeaderboard:
					# on check si il a fait un meilleur score
					if timeToFinishForSilentWolf > playerScoreInLeaderboard:
						betterScoreThanLB = true
						#et on remove son ancien scrore dans le leaderboard
						scoreSavedAtStart.remove(playerScoreInLeaderboardKey)
						
				var i = 0
					
				# ensuite on check chaque score dans l'ordre et des qu'on a fait mieux on insert le nouveau avant
				if isPlayerInLeaderboard && betterScoreThanLB || !isPlayerInLeaderboard:
					for score in scoreSavedAtStart:
						if i < 5:
							if timeToFinishForSilentWolf > score.score:
								Global.needToReloadScore = true
								highScore = true
								scoreSavedAtStart.insert(i, {"name" : Global.playerName, "score" : timeToFinishForSilentWolf})
								endGameScreenNode.get_node('HSParticles').emitting = true
								highScoreRank = i

								break
						i += 1
			
			
			#enfin on ecrit tous les scores au bon endroit
			var j = 0
	
			for score in scoreSavedAtStart:
				j += 1
				if j < 6:
					
					if j == highScoreRank + 1 :
						endGameScreenNode.get_node('Name').get_node(str(j)).bbcode_text = "[wave]" + str(score.name)
					else:
						endGameScreenNode.get_node('Name').get_node(str(j)).bbcode_text = str(score.name)
						
					var invTimeBack = (10000 - score.score)
					var LeaderboardSecs = fmod(invTimeBack, 60)
					var LeaderboardMils = fmod(invTimeBack,1)*100
					var LeaderboardTime = "%02d:%02d" % [LeaderboardSecs,LeaderboardMils]
					
					if j == highScoreRank + 1:
						endGameScreenNode.get_node('Time').get_node(str(j)).bbcode_text = "[wave]" + str(LeaderboardTime)
					else:
						endGameScreenNode.get_node('Time').get_node(str(j)).bbcode_text = str(LeaderboardTime)
			
			
		# save score
		Global.saveScore(currentLevel, levelSpeed, levelSharp, time_passed, mins, secs, mils, bulletsFired, timeToFinish)
		Global.saveFullTimeRun()
		
	Global.saveAllTimeTargets(targetShot)
	# reset targetshot
	targetShot = 0

	
func unlockNextLevel():
	if !isLastLevel:
		Global.save[0][nextLevel][7] = true
		endGameScreenNode.unlockNext()
	if currentLevel == 9:
		Global.save[2]["isJungleUnlocked"] = true

func get_results():
	# hide game UI
	endGameScreenNode.visible = true
	
	if godGunWasUsed:
		endGameScreenNode.get_node('godGunLabel').visible = true
	
	$CanvasLayer/cylinder.visible = false
	$CanvasLayer/Timer.visible = false
	
	# display results of the run
	$CanvasLayer/EndGameScreen/speed_results.bbcode_text = "[center]" + str(time_passed)
	$CanvasLayer/EndGameScreen/sharp_results.bbcode_text = "[center]" + str(bulletsFired)
	
	# display the number of stars you got for this run
	# also display the saved score if better
	if secs <= goldSpeedStar && mins < 1:
		levelSpeed = 3
		if Global.save[0][currentLevel][3] == 99: 
			speedCustomMessage.bbcode_text = "[center]YEEHAW !"
		else:	
			if (secs <= Global.save[0][currentLevel][4]) || (secs == Global.save[0][currentLevel][4] && mils <= Global.save[0][currentLevel][5]):
				speedCustomMessage.bbcode_text = "[center]best: " + str(time_passed)
			else:
				speedCustomMessage.bbcode_text = "[center]best: " + str(Global.save[0][currentLevel][2])

	elif secs <= silverSpeedStar && mins < 1:
		levelSpeed = 2
		speedCustomMessage.bbcode_text = "[center]next: " + str(goldSpeedStar)
	elif secs <= bronzeSpeedStar && mins < 1:
		levelSpeed = 1
		speedCustomMessage.bbcode_text = "[center]next: " + str(silverSpeedStar)
	else:
		levelSpeed = 0
		speedCustomMessage.bbcode_text = "[center]next: " + str(bronzeSpeedStar)


	if levelSpeed > 2:
		$CanvasLayer/EndGameScreen/Gold2/Sprite.visible = true
	else:
		$CanvasLayer/EndGameScreen/Gold2/Sprite.visible = false
	if levelSpeed > 1:
		$CanvasLayer/EndGameScreen/Silver2/Sprite.visible = true
	else:
		$CanvasLayer/EndGameScreen/Silver2/Sprite.visible = false
	if levelSpeed > 0:
		$CanvasLayer/EndGameScreen/Bronze2/Sprite.visible = true
	else:
		$CanvasLayer/EndGameScreen/Bronze2/Sprite.visible = false
	
	if bulletsFired <= goldSharpStar:
		levelSharp = 3
		if Global.save[0][currentLevel][6] == 99:
			sharpCustomMessage.bbcode_text = "[center]SHARP !"
		else:
			sharpCustomMessage.bbcode_text = "[center]best: " + str(Global.save[0][currentLevel][6])
	elif bulletsFired <= silverSharpStar:
		levelSharp = 2
		sharpCustomMessage.bbcode_text = "[center]next: " + str(goldSharpStar)
	elif bulletsFired <= bronzeSharpStar:
		levelSharp = 1
		sharpCustomMessage.bbcode_text = "[center]next: " + str(silverSharpStar)
	else:
		levelSharp = 0
		sharpCustomMessage.bbcode_text = "[center]next: " + str(bronzeSharpStar)

	if levelSharp > 2:
		$CanvasLayer/EndGameScreen/Gold/Sprite.visible = true
	else:
		$CanvasLayer/EndGameScreen/Gold/Sprite.visible = false
	if levelSharp > 1:
		$CanvasLayer/EndGameScreen/Silver/Sprite.visible = true
	else:
		$CanvasLayer/EndGameScreen/Silver/Sprite.visible = false
	if levelSharp > 0:
		$CanvasLayer/EndGameScreen/Bronze/Sprite.visible = true
	else:
		$CanvasLayer/EndGameScreen/Bronze/Sprite.visible = false

func addOneBulletsFired():
	if !levelIsFinished:
		bulletsFired += 1

