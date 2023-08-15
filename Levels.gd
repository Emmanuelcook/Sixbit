extends Node2D

func _on_Button_pressed():
	get_tree().change_scene("res://Main.tscn")
	GlobalScene.get_node('shot').play()

func goToLevel(level):
	get_tree().change_scene("res://Level" + str(level) +".tscn")
