extends Node2D



func _process(delta):
	# Can reload with R
#	if Input.is_action_just_pressed("reset"):
#		get_tree().reload_current_scene()
#
#	if Input.is_action_just_pressed("pause"):
#		if get_parent().get_parent().levelIsFinished: return true
#
#		if self.visible:
#			get_tree().paused = false
#			self.visible = false
#		else:
#			self.visible = true
#			get_tree().paused = true

	if Global.speedRunActive:
		Global.updateSRtimer(delta)
		
	

func _on_nextLevelButton_pressed():
	Global.saveAllTimeTargets(get_parent().get_parent().targetShot)	
	Global.saveAllTimeBulletsFired(get_parent().get_parent().bulletsFired - 1)	
	GlobalScene.playSound('shot')

	var nextLevel = get_parent().get_parent().nextLevel
	var isLastLevel = get_parent().get_parent().isLastLevel
	
	# Go to next level or thank you page if it was the last
	if isLastLevel:
		get_tree().change_scene("res://UI/Levels/endSpeedrunScreen.tscn")
	else:
		get_tree().change_scene("res://Levels/Desert/Level" + str(nextLevel) +".tscn")

func _on_mainButton_pressed():
	Global.resetSR()
	Global.saveAllTimeTargets(get_parent().get_parent().targetShot)	
	Global.saveAllTimeBulletsFired(get_parent().get_parent().bulletsFired - 1)	
	GlobalScene.playSound('shot')
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")


func _on_RetryRunButton_pressed():
	Global.resetSR()
	Global.saveAllTimeBulletsFired(get_parent().get_parent().bulletsFired - 1)	
	Global.saveAllTimeTargets(get_parent().get_parent().targetShot)	

	if get_tree().paused:
		GlobalScene.playSound('shot')

	get_tree().change_scene("res://Levels/Desert/Level1.tscn")
