extends Node2D

func _ready():
	get_tree().paused = false

func _on_Button_pressed():
	get_tree().change_scene("res://UI/Main.tscn")
	GlobalScene.getnode('shot').play()

func _on_Levels_pressed():
	get_tree().change_scene("res://UI/Levels.tscn")
	GlobalScene.get_node('shot').play()
