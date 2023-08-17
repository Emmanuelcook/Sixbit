extends Sprite

func shot(ballUsed):
	# On each shot, rotate the cylinder and make the ball disappear
	$Bullets.rotation_degrees += 60
	$Bullets/bullet.get_node(str(ballUsed)).visible = false

func reload():
	# 360 degres to reload animation
	$Bullets/AnimCylinder.play('reload')

func end_reload():
	#	At the end of the animation get bullets back
	for i in $Bullets/bullet.get_children():
		i.visible = true
