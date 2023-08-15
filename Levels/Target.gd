extends StaticBody2D

var gotshot = false

func got_shot():
	if gotshot: return true
	randomize()
	$shotSound.pitch_scale = rand_range(0.85,1)
	$shotSound.play()
	$Sprite.modulate = Color(0,0,0,1)
	gotshot = true
	get_node("../..").targetShot()
	
	

