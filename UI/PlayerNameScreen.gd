extends Node2D

onready var first = $first/label
onready var second = $second/label
onready var third = $third/label
var textColor = Color(.3,.26,.18,1)

func _ready():
	get_tree().paused = false
	$Go.visible = false
	$Go/Label.modulate = textColor
	

func letterPressed(letter, letterNode):
	if letter == "<":
		if third.text != "":
			third.text = ""
			GlobalScene.playSound("shot")
		elif second.text != "":
			second.text = ""
			GlobalScene.playSound("shot")	
		elif first.text != "":
			first.text = ""
			GlobalScene.playSound("shot")	
	else:	
		if first.text == "":
			first.text = letter
			GlobalScene.playSound("shot")	
		elif second.text == "":
			second.text = letter
			GlobalScene.playSound("shot")	
		elif third.text == "":
			third.text = letter
			GlobalScene.playSound("shot")	

	randomize()
	letterNode.get_node("metalHit").pitch_scale = rand_range(0.85,1)
	letterNode.get_node("metalHit").play()

func _process(_delta):
	if third.text != "":
		$Go.visible = true
	else:
		$Go.visible = false



func _on_Go_pressed():

	if third.text != "":
		Global.save[1].playerName = str(first.text) + str(second.text) + str(third.text)
		Global.saveGame()
		Global.playerName = Global.save[1].playerName 
		get_tree().change_scene_to(Global.sceneAfterNaming)
		GlobalScene.playSound("shot")
		GlobalScene.playSound("metalHit")


func _on_Go_mouse_entered():
	$Go/Label.modulate = Color(1,1,1,1)
	$Go/Sprite.visible = true


func _on_Go_mouse_exited():
	$Go/Label.modulate = textColor
	$Go/Sprite.visible = false
