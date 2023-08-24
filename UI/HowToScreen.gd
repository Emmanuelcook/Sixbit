extends Node2D

var playerStartPosY = 0
var textColor = Color(.3,.26,.18,1)
var targetShot = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_backMain_pressed():
	get_tree().change_scene("res://UI/MainNavigation.tscn")
	GlobalScene.get_node("shot").play()
	GlobalScene.get_node("click").play()


func _on_backMain_mouse_entered():
	$backMain/Label.modulate = Color(1,1,1,1)
	$backMain/Sprite.visible = true


func _on_backMain_mouse_exited():
	$backMain/Label.modulate = textColor
	$backMain/Sprite.visible = false
