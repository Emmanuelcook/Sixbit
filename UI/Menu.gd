extends Node2D

func _process(delta):
	if get_parent().get_parent().levelIsFinished: return true
	
	if Input.is_action_just_pressed("pause"):
		if self.visible:
			get_tree().paused = false
			self.visible = false
		else:
			self.visible = true
			get_tree().paused = true


func _on_Main_pressed():
	get_tree().change_scene("res://UI/Main.tscn")
	GlobalScene.get_node('shot').play()
	pass # Replace with function body.


func _on_Settings_pressed():
	pass # Replace with function body.


func _on_Levels_pressed():
	get_tree().change_scene("res://UI/Levels.tscn")
	GlobalScene.get_node('shot').play()
	pass # Replace with function body.
