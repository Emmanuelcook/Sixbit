extends Node2D

var textColor = Color(.3,.26,.18,1)

func _ready():
	get_tree().paused = false
	
	#Below only code for displaying your name if you have one
	Global.playerName = Global.save[1].playerName 

	if Global.playerName != "" && Global.playerName != null:
		$playerName.visible = true
		$playerName/Title.modulate = textColor
		$playerName/Name.modulate = textColor
		$playerName/Name.modulate = textColor
		$playerName/Name.text = Global.playerName

func _on_playerName_mouse_entered():
	$playerName/Title.modulate = Color(1,1,1,1)
	$playerName/Name.modulate = Color(1,1,1,1)

func _on_playerName_mouse_exited():
	$playerName/Title.modulate = textColor
	$playerName/Name.modulate = textColor

func _on_playerName_pressed():
	get_tree().change_scene("res://UI/PlayerNameScreen.tscn")
