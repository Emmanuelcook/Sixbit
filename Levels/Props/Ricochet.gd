extends StaticBody2D

onready var timer = $Timer

export var bipLeft = true
export var bipRight = true

func _ready():
	if !bipLeft:
		$cligno/cligno1.visible = false
		$cligno/cligno2.visible = false
	if !bipRight:
		$cligno/cligno3.visible = false
		$cligno/cligno4.visible = false

func _on_Timer_timeout():
	if bipLeft:
		if $cligno/cligno1.visible:
			$cligno/cligno1.visible = false
			$cligno/cligno2.visible = true
		else: 
			$cligno/cligno1.visible = true
			$cligno/cligno2.visible = false

	if bipRight:
		if $cligno/cligno3.visible:
			$cligno/cligno3.visible = false
			$cligno/cligno4.visible = true
		else: 
			$cligno/cligno3.visible = true
			$cligno/cligno4.visible = false

