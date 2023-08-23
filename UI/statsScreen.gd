extends Node2D

var textColor = Color(.3,.26,.18,1)

func _ready():
	get_tree().paused = false
	$changeName/Label.modulate = textColor
	$backMain/Label.modulate = textColor
	$resetSave/Label.modulate = textColor

func _on_changeName_pressed():
	Global.playerName = ""
	get_tree().change_scene("res://UI/PlayerNameScreen.tscn")
	GlobalScene.get_node("shot").play()
	GlobalScene.get_node("click").play()
	Global.sceneAfterNaming = "res://UI/statsScreen.tscn"

func _on_backMain_pressed():
	get_tree().change_scene("res://UI/MainNavigation.tscn")
	GlobalScene.get_node("shot").play()
	GlobalScene.get_node("click").play()

func _on_resetSave_pressed():
	$AreyouSure.visible = true
	GlobalScene.get_node("shot").play()
	GlobalScene.get_node("click").play()
	
func _on_NO_pressed():
	$AreyouSure.visible = false
	GlobalScene.get_node("shot").play()
	GlobalScene.get_node("click").play()
	
func _on_YES_pressed():
	GlobalScene.get_node("shot").play()
	GlobalScene.get_node("click").play()
	Global.resetSave()
	$AreyouSure.visible = false
	$resetParticles.emitting = true

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




