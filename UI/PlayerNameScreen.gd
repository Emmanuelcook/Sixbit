extends Node2D

onready var first = $first/label
onready var second = $second/label
onready var third = $third/label
var textColor = Color(.3,.26,.18,1)

func _ready():
	$Go.visible = false
	$Go/Label.modulate = textColor
	

func letterPressed(letter):
	if letter == "<":
		if third.text != "":
			third.text = ""
			GlobalScene.get_node("shot").play()	
		elif second.text != "":
			second.text = ""
			GlobalScene.get_node("shot").play()	
		elif first.text != "":
			first.text = ""
			GlobalScene.get_node("shot").play()	
	else:	
		if first.text == "":
			first.text = letter
			GlobalScene.get_node("shot").play()	
		elif second.text == "":
			second.text = letter
			GlobalScene.get_node("shot").play()	
		elif third.text == "":
			third.text = letter
			GlobalScene.get_node("shot").play()	

	GlobalScene.get_node("click").play()

func _process(_delta):
	if third.text != "":
		$Go.visible = true
	else:
		$Go.visible = false



func _on_Go_pressed():

	if third.text != "":
		print(Global.save)
		Global.save[1].playerName = str(first.text) + str(second.text) + str(third.text)
		Global.saveGame()
		get_tree().change_scene(str(Global.sceneAfterNaming))
		GlobalScene.get_node('shot').play()
		GlobalScene.get_node('click').play()


func _on_Go_mouse_entered():
	$Go/Label.modulate = Color(1,1,1,1)
	$Go/Sprite.visible = true


func _on_Go_mouse_exited():
	$Go/Label.modulate = textColor
	$Go/Sprite.visible = false
