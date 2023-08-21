extends Button

export var letter = "A"

func _ready():
	$Label.text = letter

func _on_Letter_pressed():
	get_parent().letterPressed(letter)
