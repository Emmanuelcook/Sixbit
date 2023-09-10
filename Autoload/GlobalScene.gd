extends Node2D

onready var tween = $Tween

func _ready():
	
	
	if Global._biome == Global.Biomes.DESERT:
		$ambiance.play()
	if Global._biome == Global.Biomes.JUNGLE:
		$ambianceJungle.play()
		

#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -80)
#	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)

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
		

func changeAmbianceMusic(biome):
	if biome == 0:
		if !$ambiance.playing:
			tween.interpolate_property($ambianceJungle, "volume_db", 
			0, -80, 3, 
			Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
			$ambiance.play()
			tween.interpolate_property($ambiance, "volume_db", 
			-80, 0, 3, 
			Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
			tween.start()
			yield(get_tree().create_timer(3), "timeout")
			$ambianceJungle.stop()
		
	if biome == 1:
		if !$ambianceJungle.playing:
		
			tween.interpolate_property($ambianceJungle, "volume_db", 
			-80, 0, 3, 
			Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
			tween.interpolate_property($ambiance, "volume_db", 
			0, -80, 3, 
			Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
			tween.start()
			$ambianceJungle.play()
			
			yield(get_tree().create_timer(3), "timeout")
			$ambiance.stop()
