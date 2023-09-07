extends Node2D

func _ready():
	get_tree().paused = false
	
	if Global._biome == Global.Biomes.JUNGLE:
		$BG.global_position.x -= 640
		$Desert.global_position.x -= 640
		$Jungle.global_position.x -= 640
		pass

func _on_Button_pressed():
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")
	GlobalScene.playSound('shot')

func goToLevel(level):
	get_tree().change_scene("res://Levels/Desert/Level" + str(level) +".tscn")
	
