extends Button

export(PackedScene) var lienVers
export var linkText = "linkTo"
export(Color) var textColor = Color(.3,.26,.18,1)
export var isClickable = true
export var needPlayerName = false

func _ready():
	$textLink.modulate = textColor
	$textLink.text = linkText
	
	if !isClickable:
		$notclickable.visible = true
		$textLink.self_modulate = Color(0,0,0,.5)

func _on_ButtonNav_mouse_entered():
	if isClickable:
		$textLink.modulate = Color(1,1,1,1)
		$TargetOutline.visible = true

func _on_ButtonNav_mouse_exited():
	$textLink.modulate = textColor
	$TargetOutline.visible = false


func _on_ButtonNav_pressed():
	randomize()
	$metalHit.pitch_scale = rand_range(0.85,1)
	$metalHit.play()
	
	if isClickable:
		GlobalScene.playSound("shot")
		
		if needPlayerName:
			
			if Global.playerName == "" || Global.playerName == null:
				get_tree().change_scene("res://UI/PlayerNameScreen.tscn")
				Global.sceneAfterNaming = lienVers
			else:
				get_tree().change_scene_to(lienVers)
		else :
			get_tree().change_scene_to(lienVers)
