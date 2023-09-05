extends StaticBody2D



func gotShot():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play('shot')



