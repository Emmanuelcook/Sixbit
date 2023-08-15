extends Sprite

func shot(ballUsed):
#	print("cylinder-shot")
	$Bullets.rotation_degrees += 60
	$Bullets/bullet.get_node(str(ballUsed)).visible = false

func reload():
#	print("cylinder-reload")
	$Bullets/AnimCylinder.play('reload')

func end_reload():
#	print("cylinder-endreload")
	for i in $Bullets/bullet.get_children():
		i.visible = true
