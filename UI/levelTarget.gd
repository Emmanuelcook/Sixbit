extends Node2D

export var level = 1
export(Texture) var target
export var unlockedLevel = true


func _ready():
	# check if level is unlocked
	unlockedLevel = Global.save[0][level][6]
	
	$Button/Sprite.texture = target
	
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
		get_parent().goToLevel(level)
		GlobalScene.get_node('shot').play()
	else: 
		GlobalScene.get_node('click').play()
		$hidden.modulate = Color(0,0,0,1)
		yield(get_tree().create_timer(.1), "timeout")
		$hidden.modulate = Color(1,1,1,1)
		
		
