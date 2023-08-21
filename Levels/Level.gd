extends Node2D

export var currentLevel = 1
export var isLastLevel = false
var nextLevel
var levelIsFinished

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
var targetShot = 0

onready var player = $PlayerRoot/Player

func _ready():
	
	nextLevel = currentLevel + 1 # update nextlevel number
	get_tree().paused = false # unpaused if coming from menu
	
	# Display UI but the endscreen game
	$CanvasLayer.visible = true
	$CanvasLayer/EndGameScreen.visible = false
	
	#Update the number of targets in the level
	for i in $Targets.get_children():
		targetNumber += 1
	
	# If a score is saved, display above the gun
	if Global.save[0][currentLevel][4] != 99:
		var bestTime = Global.save[0][currentLevel][2]
		var bestBullets = Global.save[0][currentLevel][6]
		$PlayerRoot/Start2.bbcode_text = '[center]Best time: ' + str(bestTime) + '\n Bullets: ' + str(bestBullets)
		$PlayerRoot/Start2.visible = true

func _process(delta):
	# display effect around the gun at the start and makes it rotate
	$PlayerRoot/Start1.global_position = player.global_position
	if $PlayerRoot/Start1.visible:
		$PlayerRoot/Start1.rotation_degrees += 1

	# Can reset the level with R
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

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
	if targetShot == targetNumber:
		ending_level()

func timer(onOrOff):
	timerState = onOrOff

func ending_level():
	# When level is finished
	# pause the game
	get_tree().paused = true
	levelIsFinished = true
	
	
		
	# Game is paused so play gunshot and targetshot
	GlobalScene.get_node("shot").play()
	GlobalScene.get_node("click").play()
	
	# stop timer
	timer(false)
	
	# display results
	get_results()
	
	# unlock next level in the levels menu
	unlockNextLevel()
	
	# save score
	Global.saveScore(currentLevel, levelSpeed, levelSharp, time_passed, mins, secs, mils, bulletsFired)
	
	# reset targetshot
	targetShot = 0

	SilentWolf.Scores.persist_score("Cle", timeToFinish, "Level " + str(currentLevel))

	yield(SilentWolf.Scores.get_high_scores(5, "Level " + str(currentLevel)), "sw_scores_received")
	var i = 0
	for score in SilentWolf.Scores.scores:
		i += 1
		print(str(i) + 'place')
		print("player" + str(score.player_name))
		print("score" + str(score.score))

func unlockNextLevel():
	if !isLastLevel:
		Global.save[0][nextLevel][7] = true

func get_results():
	# hide game UI
	$CanvasLayer/EndGameScreen.visible = true
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
			$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "[center]Like greased lightning !"
		else:	
			if (secs <= Global.save[0][currentLevel][4]) || (secs == Global.save[0][currentLevel][4] && mils <= Global.save[0][currentLevel][5]):
				$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "[center]best: " + str(time_passed)
			else:
				$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "[center]best: " + str(Global.save[0][currentLevel][2])

	elif secs <= silverSpeedStar && mins < 1:
		levelSpeed = 2
		$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "[center]next: " + str(goldSpeedStar)
	elif secs <= bronzeSpeedStar && mins < 1:
		levelSpeed = 1
		$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "[center]next: " + str(silverSpeedStar)
	else:
		levelSpeed = 0
		$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "[center]next: " + str(bronzeSpeedStar)

	if levelSpeed > 2:
		$CanvasLayer/EndGameScreen/Gold2/Sprite.visible = true
	if levelSpeed > 1:
		$CanvasLayer/EndGameScreen/Silver2/Sprite.visible = true
	if levelSpeed > 0:
		$CanvasLayer/EndGameScreen/Bronze2/Sprite.visible = true
	
	if bulletsFired <= goldSharpStar:
		levelSharp = 3
		if Global.save[0][currentLevel][6] == 99:
			$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "[center]Right on the money !"
		else:
			$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "[center]best: " + str(Global.save[0][currentLevel][6])
	elif bulletsFired <= silverSharpStar:
		levelSharp = 2
		$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "[center]next: " + str(goldSharpStar)
	elif bulletsFired <= bronzeSharpStar:
		levelSharp = 1
		$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "[center]next: " + str(silverSharpStar)
	else:
		levelSharp = 0
		$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "[center]next: " + str(bronzeSharpStar)

	if levelSharp > 2:
		$CanvasLayer/EndGameScreen/Gold/Sprite.visible = true
	if levelSharp > 1:
		$CanvasLayer/EndGameScreen/Silver/Sprite.visible = true
	if levelSharp > 0:
		$CanvasLayer/EndGameScreen/Bronze/Sprite.visible = true


