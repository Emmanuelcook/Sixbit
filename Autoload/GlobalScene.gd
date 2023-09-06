extends Node2D

func _ready():
	$ambiance.play()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)

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
		


