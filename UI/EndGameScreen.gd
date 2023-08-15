extends Node2D

func _on_retryButton_pressed():
	get_tree().reload_current_scene()

func _on_nextButton_pressed():
	get_tree().change_scene("res://UI/Levels.tscn")

func _on_backToLevel_pressed():
	var nextLevel = get_parent().get_parent().nextLevel
	var isLastLevel = get_parent().get_parent().isLastLevel
	
	if isLastLevel:
		get_tree().change_scene("res://UI/Thanks.tscn")
	else:
		get_tree().change_scene("res://Levels/Level" + str(nextLevel) +".tscn")
	GlobalScene.get_node('shot').play()
