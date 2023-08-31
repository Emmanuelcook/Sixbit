extends Node2D

func _ready():
#	$ambiance.play()
	pass
	

func playSound(sound):
	if sound == "metalHit":
		randomize()
		$metalHit.pitch_scale = rand_range(0.85,1)
		$metalHit.play()
	if sound == "shot":
		randomize()
		$shot.pitch_scale = rand_range(0.85,1)
		$shot.play()
	if sound == "unlocked":
		$unlocked.play()
	if sound == "monkey":
		$monkey.play()
		


