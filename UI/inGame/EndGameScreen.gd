extends Node2D

func _ready():
	
	if Global.speedRunActive:
		$LevelsButton.text = "Stop Speedrun"
		$nextLevelButton.visible = false
		$retryButton.visible = false
		$LevelsButton.visible = false
	else: 
		$SRRetryButton.visible = false
		$SRStopSR.visible = false

func _process(delta):
	# Can reload with R
#	if Input.is_action_just_pressed("reset"):
#		get_tree().reload_current_scene()
		
	if Input.is_action_just_pressed("pause"):
		
			if get_parent().get_parent().levelIsFinished: return true
			
			if self.visible:
				if !Global.speedRunActive:
					get_tree().paused = false
				self.visible = false
			else:
				if !Global.speedRunActive:
					get_tree().paused = true
				self.visible = true
	
	
func _on_retryButton_pressed():
	saveGlobalStats()

	if get_tree().paused:
		GlobalScene.playSound('shot')
	get_tree().reload_current_scene()

func _on_LevelsButton_pressed():

	Global.resetSR()
	
	saveGlobalStats()
	
	if get_tree().paused:
		GlobalScene.playSound('shot')
	Global.needToReloadScore = true
	get_tree().change_scene("res://UI/Levels/Levels.tscn")

func _on_nextLevelButton_pressed():
	saveGlobalStats()
	GlobalScene.playSound('shot')
	Global.needToReloadScore = true
	var nextLevel = get_parent().get_parent().nextLevel
	var isLastLevel = get_parent().get_parent().isLastLevel
	
	# Go to next level or thank you page if it was the last
	if !isLastLevel:
		if Global._biome == Global.Biomes.DESERT:
			get_tree().change_scene("res://Levels/Desert/Level" + str(nextLevel) +".tscn")
		if Global._biome == Global.Biomes.JUNGLE:
			get_tree().change_scene("res://Levels/Jungle/Level" + str(nextLevel) +".tscn")


func _on_SRStopSR_pressed():
	saveGlobalStats()	
	Global.resetSR()
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")

func _on_SRRetryButton_pressed():
	saveGlobalStats()
	get_tree().reload_current_scene()


func _on_Main_pressed():
	saveGlobalStats()
	Global.resetSR()
	Global.speedRunFinished = false
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")


func _on_SeeSRLB_pressed():
	saveGlobalStats()
#	Global.resetSR()
#	Global.speedRunFinished = false
	get_tree().change_scene("res://UI/inGame/speedRunLeaderboard.tscn")



func _on_RetrySpeedRun_pressed():
	Global.resetSR()	
	Global.speedRunActive = true
	Global.speedRunFinished = false
	get_tree().change_scene("res://Levels/Desert/Level1.tscn")


func saveGlobalStats():
	Global.saveAllTimeTargets(get_parent().get_parent().targetShot)	
	Global.saveAllTimeBulletsFired(get_parent().get_parent().bulletsFired)	 # moins 1 pour enlever celle ou on appuie sur le menu c'est tout.
	
