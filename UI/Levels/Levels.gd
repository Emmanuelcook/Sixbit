extends Node2D

func _ready():
	get_tree().paused = false

func _on_Button_pressed():
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")
	GlobalScene.playSound('shot')

func goToLevel(level):
	get_tree().change_scene("res://Levels/Desert/Level" + str(level) +".tscn")
