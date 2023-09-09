extends Node2D

export var effectSize = 10
var currentSize = 0
var ratio = 0

func changeBiome():
	if Global._biome == 0:
		effectSize = 10
	elif Global._biome == 1:
		effectSize = 6
	
func targetShot():
	currentSize += effectSize
	
func _process(delta):
	currentSize = lerp(currentSize, ratio, .2)
	update()
	
func _draw():
	draw_rect(Rect2(0, 0, 640, currentSize), Color(1,1,1))
	draw_rect(Rect2(0, 480 - currentSize, 640, currentSize), Color(1,1,1))
	draw_rect(Rect2(0, 0, currentSize, 480), Color(1,1,1))
	draw_rect(Rect2(640 - currentSize, 0, currentSize, 480), Color(1,1,1))


