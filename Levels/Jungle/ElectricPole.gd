extends StaticBody2D

var goRevolver = false

func _process(delta):
	if goRevolver:
		$revolver.global_position = get_parent().get_parent().get_node("PlayerRoot/Player").global_position
	

func gotShot(player):
	$lightning.frame = 0
	$lightning.play('shot')
	$lightningbubble.frame = 0
	$lightningbubble.play('shot')
	$lightning2.frame = 0
	$lightning2.play('shot')
	goRevolver = true
	$revolver.frame = 0
	$revolver.play('shot')



