extends Button

export var letter = "A"

func _ready():
	$Node2D/Label.text = letter

func _on_Letter_pressed():
	$AnimationPlayer.play("shot")
	get_parent().letterPressed(letter)
