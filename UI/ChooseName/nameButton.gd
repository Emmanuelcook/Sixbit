extends Button

export var letter = "A"

func _ready():
	$Node2D/Label.text = letter

#	if Global._biome == Global.Biomes.JUNGLE:
#		$bgDesert.visible = false
#		$bgJungle.visible = true
		
func _on_Letter_pressed():
	$AnimationPlayer.play("shot")
	get_parent().letterPressed(letter, self)
