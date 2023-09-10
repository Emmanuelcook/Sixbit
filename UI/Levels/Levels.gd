extends Node2D

func _ready():
	get_tree().paused = false
	
	if Global._biome == Global.Biomes.JUNGLE:
		$BG.global_position.x -= 640
		$Desert.global_position.x -= 640
		$Jungle.global_position.x -= 640
		pass
	
	
	if Global._biome != Global.Biomes.JUNGLE && Global.save[2]["isJungleUnlocked"] && !Global.save[0][12][7]:
		
		unlockJungle()
	elif Global.save[2]["isJungleUnlocked"]: 
		$Desert/goRight.visible = true
		$Desert/goRight.modulate = Color(1,1,1,1)
	

	
func _on_Button_pressed():
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")
	GlobalScene.playSound('shot')

func goToLevel(level):
	if Global._biome == Global.Biomes.JUNGLE:
		get_tree().change_scene("res://Levels/Jungle/Level" + str(level) +".tscn")
	if Global._biome == Global.Biomes.DESERT:
		get_tree().change_scene("res://Levels/Desert/Level" + str(level) +".tscn")

func unlockJungle():
	yield(get_tree().create_timer(.5), "timeout")
	$Desert/goRight.visible = true
	var tween = $Tween
	tween.interpolate_property($Desert/goRight, "modulate",
			Color(1,1,1,0), Color(1,1,1,1), .5,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(1), "timeout")
	GlobalScene.playSound("monkey")
	var from = Vector2($BG.global_position.x, $BG.global_position.y)
	var to =Vector2($BG.global_position.x - 640, $BG.global_position.y)
	var from2 = Vector2($Desert.global_position.x, $Desert.global_position.y)
	var to2 =Vector2($Desert.global_position.x - 640, $Desert.global_position.y)
	var from3 = Vector2($Jungle.global_position.x, $Jungle.global_position.y)
	var to3 =Vector2($Jungle.global_position.x - 640, $Jungle.global_position.y)
	tween.interpolate_property($BG, "position",
			from, to, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.interpolate_property($Desert, "position",
			from2, to2, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.interpolate_property($Jungle, "position",
			from3, to3, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.start()
	Global._biome = Global.Biomes.JUNGLE
	Global.save[2]["actualBiome"] = 1
	Global.saveGame()
	GlobalScene.changeAmbianceMusic(1)	

	
func _on_goRight_pressed():
	var tween = $Tween
	var from = Vector2($BG.global_position.x, $BG.global_position.y)
	var to =Vector2($BG.global_position.x - 640, $BG.global_position.y)
	var from2 = Vector2($Desert.global_position.x, $Desert.global_position.y)
	var to2 =Vector2($Desert.global_position.x - 640, $Desert.global_position.y)
	var from3 = Vector2($Jungle.global_position.x, $Jungle.global_position.y)
	var to3 =Vector2($Jungle.global_position.x - 640, $Jungle.global_position.y)
	tween.interpolate_property($BG, "position",
			from, to, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.interpolate_property($Desert, "position",
			from2, to2, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.interpolate_property($Jungle, "position",
			from3, to3, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.start()
	Global._biome = Global.Biomes.JUNGLE
	Global.save[2]["actualBiome"] = 1
	Global.saveGame()
	GlobalScene.changeAmbianceMusic(1)


func _on_goLeft_pressed():
	var tween = $Tween
	var from = Vector2($BG.global_position.x, $BG.global_position.y)
	var to =Vector2($BG.global_position.x + 640, $BG.global_position.y)
	var from2 = Vector2($Desert.global_position.x, $Desert.global_position.y)
	var to2 =Vector2($Desert.global_position.x + 640, $Desert.global_position.y)
	var from3 = Vector2($Jungle.global_position.x, $Jungle.global_position.y)
	var to3 =Vector2($Jungle.global_position.x + 640, $Jungle.global_position.y)
	tween.interpolate_property($BG, "position",
			from, to, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.interpolate_property($Desert, "position",
			from2, to2, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.interpolate_property($Jungle, "position",
			from3, to3, 1,
			Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
	tween.start()
	Global._biome = Global.Biomes.DESERT
	Global.save[2]["actualBiome"] = 0
	Global.saveGame()
	GlobalScene.changeAmbianceMusic(0)	
