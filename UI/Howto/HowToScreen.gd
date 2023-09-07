extends Node2D

var playerStartPosY = 0
var textColor = Color(.3,.26,.18,1)
var targetShot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if Global._biome == Global.Biomes.JUNGLE:
		$BG/bgDesert.visible = false
		$BG/bgJungle.visible = true
		$BG/SpriteDesert.visible = false
		$BG/SpriteJungle.visible = true
		textColor = Color(1,1,1,1)
		$fulleRunTitle.set("custom_colors/font_color", Color(1,1,1))
		$bulletsTitle.set("custom_colors/font_color", Color(1,1,1))
		$bulletsTitle2.set("custom_colors/font_color", Color(1,1,1))
		$SpeedRunTitle.set("custom_colors/font_color", Color(1,1,1))
		$SpeedRunTitle2.set("custom_colors/font_color", Color(1,1,1))
		
	playerStartPosY = $howToPlayr.global_position.y
	pass # Replace with function body.

func _process(delta):
	
	# Can reload with R
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	if $howToPlayr.global_position.y > 800:
		get_tree().reload_current_scene()
	
	if targetShot == 3:
		$howtoParticles.emitting = true
		$howtoParticles2.emitting = true
		$howtoParticles3.emitting = true
		targetShot = 0
		$Timer.start()

func _on_backMain_pressed():
	get_tree().change_scene("res://UI/TitleMenu/MainNavigation.tscn")
	GlobalScene.playSound('shot')
	GlobalScene.playSound("metalHit")

func _on_backMain_mouse_entered():
	$backMain/Label.modulate = Color(1,1,1,1)
	$backMain/Sprite.visible = true

func _on_backMain_mouse_exited():
	$backMain/Label.modulate = textColor
	$backMain/Sprite.visible = false

func _on_Timer_timeout():
	$Targets/Target/Sprite.modulate = 	Color(1,1,1,1)
	$Targets/Target2/Sprite.modulate = 	Color(1,1,1,1)
	$Targets/Target3/Sprite.modulate = 	Color(1,1,1,1)
	$Targets/Target.gotshot = false
	$Targets/Target2.gotshot = false
	$Targets/Target3.gotshot = false
