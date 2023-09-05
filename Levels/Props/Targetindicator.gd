extends AnimatedSprite


func gotShot():
	self.play("shot")
	$ricochet.emitting = true
