extends Node2D

func _process(delta):
	# Can reload with R
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func _on_retryButton_pressed():
	get_tree().reload_current_scene()

func _on_LevelsButton_pressed():
	get_tree().change_scene("res://UI/Levels.tscn")
	GlobalScene.get_node('shot').play()

func _on_nextLevelButton_pressed():
	var nextLevel = get_parent().get_parent().nextLevel
	var isLastLevel = get_parent().get_parent().isLastLevel
	GlobalScene.get_node('shot').play()
	
	# Go to next level or thank you page if it was the last
	if isLastLevel:
		get_tree().change_scene("res://UI/Thanks.tscn")
	else:
		get_tree().change_scene("res://Levels/Level" + str(nextLevel) +".tscn")
	
	
