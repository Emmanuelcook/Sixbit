extends Node2D

export var level = 1
export var unlockedLevel = true



func _ready():
	
	$Button/Label.text = str(fmod(level, 10))
	
	# check if level is unlocked
	unlockedLevel = Global.save[0][level][7]
	
	if !unlockedLevel:
		$hidden.visible = true
		$stars.visible = false
	else:
		updateStars()
		$hidden.visible = false
		$stars.visible = true

func updateStars():
	var speed = Global.save[0][level][0] 
	var sharp = Global.save[0][level][1] 

	if speed > 0:
		$"stars/speed/1/star".visible = true
	if speed > 1:
		$"stars/speed/2/star".visible = true
	if speed > 2:
		$"stars/speed/3/star".visible = true
	if sharp > 0:
		$"stars/sharp/1/star".visible = true
	if sharp > 1:
		$"stars/sharp/2/star".visible = true
	if sharp > 2:
		$"stars/sharp/3/star".visible = true
	
func _on_Button_pressed():
	
	if unlockedLevel:
		get_parent().get_parent().goToLevel(level)
		GlobalScene.playSound('shot')
	else: 
		GlobalScene.playSound("metalHit")
		$hidden.modulate = Color(0,0,0,1)
		yield(get_tree().create_timer(.1), "timeout")
		$hidden.modulate = Color(1,1,1,1)
		

func _on_Button_mouse_entered():
	if unlockedLevel:
		var tween = $Button/Tween
		tween.interpolate_property($Button/Sprite, "position",
				Vector2(60, 30), Vector2(60, 25), .3,
				Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
		tween.interpolate_property($Button/Label, "margin_top",
				13, 8, .35,
				Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
		tween.start()

func _on_Button_mouse_exited():
	if unlockedLevel:
		var tween = $Button/Tween
		tween.interpolate_property($Button/Sprite, "position",
				Vector2(60, 25), Vector2(60, 30), .3,
				Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
		tween.interpolate_property($Button/Label, "margin_top",
				8, 13, .35,
				Tween.TRANS_CUBIC , Tween.EASE_IN_OUT)
		tween.start()
