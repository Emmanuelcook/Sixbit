extends Line2D

onready var tween = $Decay

export var limited_lifetime = false
export var wildness = 3.0

var gravity = Vector2.UP
var lifetime = [1.0, 2.0]
var tick_speed = 0.05
var tick = 0.0
var wild_speed = 0.1

func _ready():
	if limited_lifetime:
		tween.interpolate_property(self, "modulate:a", 1.0, 0.0, rand_range(lifetime[0], lifetime[1]), Tween.TRANS_CIRC, Tween.EASE_OUT)
		tween.start()

func _process(delta):
		
	if tick > tick_speed:
		tick = 0
		for p in range(get_point_count()):
			var rand_vector := Vector2(rand_range(-wild_speed, wild_speed), rand_range(-wild_speed, wild_speed))
			points[p] += gravity + (rand_vector * wildness)
	else: 
		tick += delta

func _on_Decay_tween_all_completed():
	queue_free()
