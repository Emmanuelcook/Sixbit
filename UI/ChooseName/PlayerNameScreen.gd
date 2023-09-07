extends Node2D

onready var first = $first/label
onready var second = $second/label
onready var third = $third/label
var textColor = Color(.3,.26,.18,1)

func _ready():
	get_tree().paused = false
	if Global._biome == Global.Biomes.JUNGLE:
		$Label.set("custom_colors/font_color", Color(1,1,1))
		$first/label.set("custom_colors/font_color", Color(1,1,1))
		$second/label.set("custom_colors/font_color", Color(1,1,1))
		$third/label.set("custom_colors/font_color", Color(1,1,1))
#		$Go/bgDesert.visible = false
#		$Go/bgJungle.visible = true
		textColor = Color(1,1,1,1)
		
	$Go.visible = false
	$Go/Label.modulate = textColor
	

func letterPressed(letter, letterNode):
	if letter == "<":
		if first.text != "":
			GlobalScene.playSound("shot")	
		if third.text != "":
			third.text = ""
		elif second.text != "":
			second.text = ""
		elif first.text != "":
			first.text = ""
			

	else:	
		if third.text == "":
			GlobalScene.playSound("shot")	
		if first.text == "":
			first.text = letter
		elif second.text == "":
			second.text = letter
		elif third.text == "":
			third.text = letter

		
			

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
		
		if Global.sceneAfterNaming != "":
			get_tree().change_scene(Global.sceneAfterNaming)
		else:
			get_tree().change_scene("res://UI/Stats/statsScreen.tscn")
		
		Global.sceneAfterNaming = ""
		GlobalScene.playSound("shot")
		GlobalScene.playSound("metalHit")


func _on_Go_mouse_entered():
	$Go/Label.modulate = Color(1,1,1,1)
	$Go/Sprite.visible = true


func _on_Go_mouse_exited():
	$Go/Label.modulate = textColor
	$Go/Sprite.visible = false
