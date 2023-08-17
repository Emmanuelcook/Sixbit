extends Node2D

export var currentLevel = 1
export var isLastLevel = false
var nextLevel
var levelIsFinished

# Rank to get stars
export var bronzeSpeedStar = 8
export var silverSpeedStar = 6
export var goldSpeedStar = 4
export var bronzeSharpStar = 7
export var silverSharpStar = 6
export var goldSharpStar = 5

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

# Number of targets in the level / Number of targets shots
var targetNumber = 0
var targetShot = 0

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
	if Global.save[0][currentLevel][5] != 99:
		var bestTime = Global.save[0][currentLevel][2]
		var bestBullets = Global.save[0][currentLevel][5]
		$PlayerRoot/Start2.bbcode_text = '[center]Best time: ' + str(bestTime) + '\n Bullets: ' + str(bestBullets)
		$PlayerRoot/Start2.visible = true

func _process(delta):
	
	# display effect around the gun at the start and makes it rotate
	$PlayerRoot/Start1.global_position = $PlayerRoot/Player.global_position
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
		
		time_passed = "%02d:%02d" % [secs,mils]
	
	# display result of the time
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
	Global.saveScore(currentLevel, levelSpeed, levelSharp, time_passed, secs, mils, bulletsFired)
	
	# reset targetshot
	targetShot = 0

func unlockNextLevel():
	if !isLastLevel:
		Global.save[0][nextLevel][6] = true

func get_results():
	# hide game UI
	$CanvasLayer/EndGameScreen.visible = true
	$CanvasLayer/cylinder.visible = false
	$CanvasLayer/Timer.visible = false
	
	# display results of the run
	$CanvasLayer/EndGameScreen/speed_results.bbcode_text = str(time_passed)
	$CanvasLayer/EndGameScreen/sharp_results.bbcode_text = str(bulletsFired)
	
	# display the number of stars you got for this run
	# also display the saved score if better
	if secs <= goldSpeedStar:
		levelSpeed = 3
		if Global.save[0][currentLevel][3] == 99: 
			$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "Like greased lightning !"
		else:	
			if (secs <= Global.save[0][currentLevel][3]) || (secs == Global.save[0][currentLevel][3] && mils <= Global.save[0][currentLevel][4]):
				$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "Your best: " + str(time_passed)
			else:
				$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "Your best: " + str(Global.save[0][currentLevel][2])

	elif secs <= silverSpeedStar:
		levelSpeed = 2
		$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "3 star: " + str(goldSpeedStar) + " sec"
	elif secs <= bronzeSpeedStar:
		levelSpeed = 1
		$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "2 star: " + str(silverSpeedStar) + " sec"
	else:
		levelSpeed = 0
		$CanvasLayer/EndGameScreen/speed_nextOrBest.bbcode_text = "1 star: " + str(bronzeSpeedStar) + " sec"

	if levelSpeed > 2:
		$CanvasLayer/EndGameScreen/Gold2/Sprite.visible = true
	if levelSpeed > 1:
		$CanvasLayer/EndGameScreen/Silver2/Sprite.visible = true
	if levelSpeed > 0:
		$CanvasLayer/EndGameScreen/Bronze2/Sprite.visible = true
	
	if bulletsFired <= goldSharpStar:
		levelSharp = 3
		if Global.save[0][currentLevel][5] == 99:
			$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "Right on the money !"
		else:
			$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "Your best: " + str(Global.save[0][currentLevel][5]) + " bullets"
	elif bulletsFired <= silverSharpStar:
		levelSharp = 2
		$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "3 star: " + str(goldSharpStar) + " bullets"
	elif bulletsFired <= bronzeSharpStar:
		levelSharp = 1
		$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "2 star: " + str(silverSharpStar) + " bullets"
	else:
		levelSharp = 0
		$CanvasLayer/EndGameScreen/sharp_nextOrBest.bbcode_text = "1 star: " + str(bronzeSharpStar) + " bullets"

	if levelSharp > 2:
		$CanvasLayer/EndGameScreen/Gold/Sprite.visible = true
	if levelSharp > 1:
		$CanvasLayer/EndGameScreen/Silver/Sprite.visible = true
	if levelSharp > 0:
		$CanvasLayer/EndGameScreen/Bronze/Sprite.visible = true


