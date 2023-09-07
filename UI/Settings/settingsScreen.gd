extends Node2D

var textColor = Color(.3,.26,.18,1)
var jungleGrabber = preload("res://assets/sprites/UI/targetJunglesettings.png")

func _ready():
	$musicVol.value = Global.musicVol
	$SFXVol.value = Global.sfxVol
	$TraumaCam.value = Global.maxTrauma
	
	if Global._biome == Global.Biomes.JUNGLE:
		$BG/bgDesert.visible = false
		$BG/bgJungle.visible = true
#		$backMain/SpriteDesert.visible = false
#		$backMain/SpriteJungle.visible = true
		
		$MusicLabel.set("custom_colors/font_color", Color(1,1,1))
		$SFXLabel.set("custom_colors/font_color", Color(1,1,1))
		$traumaLabel.set("custom_colors/font_color", Color(1,1,1))
#		$TraumaCam.set("custom_icons/tick", jungleGrabber)
#		$TraumaCam.set("custom_icons/grabber_disabled", jungleGrabber)
#		$TraumaCam.set("custom_icons/grabber_highlight", jungleGrabber)
#		$TraumaCam.set("custom_icons/grabber", jungleGrabber)
#		$SFXVol.set("custom_icons/tick", jungleGrabber)
#		$SFXVol.set("custom_icons/grabber_disabled", jungleGrabber)
#		$SFXVol.set("custom_icons/grabber_highlight", jungleGrabber)
#		$SFXVol.set("custom_icons/grabber", jungleGrabber)
#		$musicVol.set("custom_icons/tick", jungleGrabber)
#		$musicVol.set("custom_icons/grabber_disabled", jungleGrabber)
#		$musicVol.set("custom_icons/grabber_highlight", jungleGrabber)
#		$musicVol.set("custom_icons/grabber", jungleGrabber)
		
		textColor = Color(1,1,1,1)

func _on_backMain_pressed():
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")
	GlobalScene.playSound("shot")
	GlobalScene.playSound("metalHit")

func _on_backMain_mouse_entered():
	$backMain/Label.modulate = Color(1,1,1,1)
	$backMain/Sprite.visible = true

func _on_backMain_mouse_exited():
	$backMain/Label.modulate = textColor
	$backMain/Sprite.visible = false

func _on_musicVol_value_changed(value):
	Global.musicVol = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)

func _on_SFXVol_value_changed(value):
	Global.sfxVol = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)

func _on_TraumaCam_value_changed(value):
	Global.maxTrauma = value
