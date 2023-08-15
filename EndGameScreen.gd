extends Node2D

func _on_retryButton_pressed():
	get_tree().reload_current_scene()

func _on_nextButton_pressed():
	get_tree().change_scene("res://Levels.tscn")

func _on_backToLevel_pressed():
	get_tree().change_scene_to(get_parent().get_parent().nextLevel)
