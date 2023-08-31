extends Button

export var lienVers = ""
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
	GlobalScene.playSound("metalHit")
	
	if isClickable:
		GlobalScene.playSound("shot")
		
		if needPlayerName:
			
			if Global.playerName == "" || Global.playerName == null:
				get_tree().change_scene("res://UI/ChooseName/PlayerNameScreen.tscn")
				Global.sceneAfterNaming = lienVers
				print(Global.sceneAfterNaming)
			else:
				get_tree().change_scene(lienVers)
		else :
			get_tree().change_scene(lienVers)
