extends Node2D

func _process(delta):

	if Input.is_action_just_pressed("pause"):
		if get_parent().get_parent().levelIsFinished: return true
		
		if self.visible:
			get_tree().paused = false
			self.visible = false
		else:
			self.visible = true
			get_tree().paused = true


func _on_Main_pressed():
	get_tree().change_scene("res://UI/MainNavigation.tscn")
	GlobalScene.get_node('shot').play()



func _on_Settings_pressed():
	pass 

func _on_Levels_pressed():
	get_tree().change_scene("res://UI/Levels.tscn")
	GlobalScene.get_node('shot').play()

