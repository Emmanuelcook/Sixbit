extends Node2D

var textColor = Color(.3,.26,.18,1)

func _ready():
	get_tree().paused = false
	
	if Global._biome == Global.Biomes.JUNGLE:
		$BG/bgDesert.visible = false
		$BG/bgJungle.visible = true
		textColor = Color(1,1,1,1)
		
#		$backMain/SpriteDesert.visible = false
#		$backMain/SpriteJungle.visible = true
#		$resetSave/SpriteDesert.visible = false
#		$resetSave/SpriteJungle.visible = true
#		$changeName/SpriteDesert.visible = false
#		$changeName/SpriteJungle.visible = true
		
		$fulleRunTitle.set("custom_colors/font_color", Color(1,1,1))
		$fullRunStat.set("custom_colors/font_color", Color(1,1,1))
		$speedRunStat.set("custom_colors/font_color", Color(1,1,1))
		$SpeedRunTitle.set("custom_colors/font_color", Color(1,1,1))
		$bulletsTitle.set("custom_colors/font_color", Color(1,1,1))
		$targetsTitle.set("custom_colors/font_color", Color(1,1,1))
		$accuracyTitle.set("custom_colors/font_color", Color(1,1,1))
		$bulletsStat.set("custom_colors/font_color", Color(1,1,1))
		$targetsStat.set("custom_colors/font_color", Color(1,1,1))
		$accuracyStat.set("custom_colors/font_color", Color(1,1,1))
		
		
		
		
	$changeName/Label.modulate = textColor
	$backMain/Label.modulate = textColor
	$resetSave/Label.modulate = textColor

	if Global.save[2]["fullRunTime"] != 0:
		
		var mils = fmod(Global.save[2]["fullRunTime"],1)*100
		var secs = fmod(Global.save[2]["fullRunTime"], 60)
		var mins = fmod(Global.save[2]["fullRunTime"], 60*60) / 60

		var fullTime
		
		if mins >= 1:
			fullTime = "%02d:%02d:%02d" % [mins,secs,mils]
		else:
			fullTime = "%02d:%02d" % [secs,mils]
		
		$fullRunStat.text = fullTime
	
	if Global.save[2]["speedRunTime"] != 0:
		
		var mils = fmod(Global.save[2]["speedRunTime"],1)*100
		var secs = fmod(Global.save[2]["speedRunTime"], 60)
		var mins = fmod(Global.save[2]["speedRunTime"], 60*60) / 60

		var fullTime
		
		if mins >= 1:
			fullTime = "%02d:%02d:%02d" % [mins,secs,mils]
		else:
			fullTime = "%02d:%02d" % [secs,mils]
		
		$speedRunStat.text = fullTime
		
	
	if Global.save[2]["allTimebulletsShot"] == 0:
		$accuracyStat.text = "-%"
	else:	
		Global.save[2]["accuracy"] = (Global.save[2]["AllTimetargetHits"] * 100) / Global.save[2]["allTimebulletsShot"]
		$accuracyStat.text = str(stepify(Global.save[2]["accuracy"], 0.01)) + "%"
	
	Global.saveGame()
	
	$bulletsStat.text = str(Global.save[2]["allTimebulletsShot"])
	$targetsStat.text = str(Global.save[2]["AllTimetargetHits"])

	
func _on_changeName_pressed():
	Global.playerName = ""
	GlobalScene.playSound('shot')
	GlobalScene.playSound("metalHit")
	get_tree().change_scene("res://UI/ChooseName/PlayerNameScreen.tscn")
	

func _on_backMain_pressed():
	GlobalScene.playSound('shot')	
	GlobalScene.playSound("metalHit")
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")
	

func _on_resetSave_pressed():
	$AreyouSure.visible = true
	GlobalScene.playSound('shot')	
	GlobalScene.playSound("metalHit")
	
	
func _on_NO_pressed():
	$AreyouSure.visible = false
	GlobalScene.playSound('shot')	
	GlobalScene.playSound("metalHit")
	
func _on_YES_pressed():
	GlobalScene.playSound('shot')	
	GlobalScene.playSound("metalHit")
	Global.resetSave()
	$AreyouSure.visible = false
	$resetParticles.emitting = true
	
	$fullRunStat.text = "--:--"
	$accuracyStat.text = "-%"
	$bulletsStat.text = str(Global.save[2]["allTimebulletsShot"])
	$targetsStat.text = str(Global.save[2]["AllTimetargetHits"])
	

func _on_changeName_mouse_entered():
	$changeName/Label.modulate = Color(1,1,1,1)
	$changeName/Sprite.visible = true

func _on_changeName_mouse_exited():
	$changeName/Label.modulate = textColor
	$changeName/Sprite.visible = false

func _on_backMain_mouse_entered():
	$backMain/Label.modulate = Color(1,1,1,1)
	$backMain/Sprite.visible = true

func _on_backMain_mouse_exited():
	$backMain/Label.modulate = textColor
	$backMain/Sprite.visible = false

func _on_resetSave_mouse_entered():
	$resetSave/Label.modulate = Color(1,1,1,1)
	$resetSave/Sprite.visible = true

func _on_resetSave_mouse_exited():
	$resetSave/Label.modulate = textColor
	$resetSave/Sprite.visible = false




