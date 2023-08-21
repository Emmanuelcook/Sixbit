extends Node2D

func _ready():
	get_tree().paused = false

func _on_Button_pressed():
	get_tree().change_scene("res://UI/MainNavigation.tscn")
	GlobalScene.get_node('shot').play()

func goToLevel(level):
	get_tree().change_scene("res://Levels/Level" + str(level) +".tscn")
