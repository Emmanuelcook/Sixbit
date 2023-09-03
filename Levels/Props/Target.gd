extends StaticBody2D

var gotshot = false
export var isOnScreen = false

func got_shot():
	if gotshot: return true
	randomize()
	$shotSound.pitch_scale = rand_range(0.85,1)
	$shotSound.play()
	gotshot = true
	get_node("../..").targetShot()
	$hit.visible = true
	$Timer.start()

func _on_Timer_timeout():
	$hit.visible = false
	$Sprite.modulate = Color(0,0,0,1)


func _on_VisibilityNotifier2D_screen_entered():
	isOnScreen = true

func _on_VisibilityNotifier2D_screen_exited():
	isOnScreen = false

