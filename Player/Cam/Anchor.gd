extends Position2D

onready var player = get_node("../Player")

# Level of smoothness when following the player
export var dampingX = 0.1
export var dampingY = 0.1

func _process(delta):
	# Get camera to follow the player
	var target = player.global_position 
	var target_pos_x
	var target_pos_y
	target_pos_x = int(lerp(global_position.x, target.x, dampingX))
	target_pos_y = int(lerp(global_position.y, target.y, dampingY))
	global_position = Vector2(target_pos_x, target_pos_y)
	
