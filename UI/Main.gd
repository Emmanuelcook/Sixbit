extends Node2D

func _on_Button_pressed():
	get_tree().change_scene("res://UI/Levels.tscn")

func _process(delta):
	if Input.is_action_just_pressed("click"):
		GlobalScene.get_node('shot').play()
		

func _on_target1_pressed():
	$target1/Sprite.visible = true
	GlobalScene.get_node('click').play()

func _on_target2_pressed():
	$target2/Sprite.visible = true
	GlobalScene.get_node('click').play()

func _on_target3_pressed():
	$target3/Sprite.visible = true
	GlobalScene.get_node('click').play()

func _on_target4_pressed():
	$target4/Sprite.visible = true
	GlobalScene.get_node('click').play()
	
func _on_target5_pressed():
	$target5/Sprite.visible = true
	GlobalScene.get_node('click').play()



