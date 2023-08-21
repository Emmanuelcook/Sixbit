extends Node2D

var textColor = Color(.3,.26,.18,1)


func _ready():
	Global.playerName = Global.save[1].playerName 

	$Levels/Label.modulate = textColor
	$SpeedRun/Label.modulate = textColor
	$How/Label.modulate = textColor
	$Settings/Label.modulate = textColor
	$Stats/Label.modulate = textColor

func _on_Levels_pressed():
	if Global.playerName == "":
		get_tree().change_scene("res://UI/PlayerNameScreen.tscn")
		Global.sceneAfterNaming = "res://UI/Levels.tscn"
	else:
		get_tree().change_scene("res://UI/Levels.tscn")
		
	GlobalScene.get_node('shot').play()
	GlobalScene.get_node('click').play()

func _on_SpeedRun_pressed():
	GlobalScene.get_node('shot').play()
	GlobalScene.get_node('click').play()


func _on_How_pressed():
	GlobalScene.get_node('shot').play()
	GlobalScene.get_node('click').play()


func _on_Settings_pressed():
	GlobalScene.get_node('shot').play()
	GlobalScene.get_node('click').play()


func _on_Stats_pressed():
	GlobalScene.get_node('shot').play()
	GlobalScene.get_node('click').play()




func _on_Levels_mouse_entered():
	$Levels/Label.modulate = Color(1,1,1,1)
	$Levels/Sprite.visible = true

func _on_SpeedRun_mouse_entered():
	$SpeedRun/Label.modulate = Color(1,1,1,1)
	$SpeedRun/Sprite.visible = true

func _on_How_mouse_entered():
	$How/Label.modulate = Color(1,1,1,1)
	$How/Sprite.visible = true

func _on_Settings_mouse_entered():
	$Settings/Label.modulate = Color(1,1,1,1)
	$Settings/Sprite.visible = true
	
func _on_Stats_mouse_entered():
	$Stats/Label.modulate = Color(1,1,1,1)
	$Stats/Sprite.visible = true

	
func _on_Levels_mouse_exited():
	$Levels/Label.modulate = textColor
	$Levels/Sprite.visible = false

func _on_SpeedRun_mouse_exited():
	$SpeedRun/Label.modulate = textColor
	$SpeedRun/Sprite.visible = false

func _on_How_mouse_exited():
	$How/Label.modulate = textColor
	$How/Sprite.visible = false

func _on_Settings_mouse_exited():
	$Settings/Label.modulate = textColor
	$Settings/Sprite.visible = false

func _on_Stats_mouse_exited():
	$Stats/Label.modulate = textColor
	$Stats/Sprite.visible = false
