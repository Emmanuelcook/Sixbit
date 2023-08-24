extends CPUParticles2D

onready var player = get_parent().get_node("PlayerRoot/Player")

func _process(delta):
	global_position = player.global_position

func emitOne():
	self.restart()

func emit(isEmitting):
	self.emitting = isEmitting
	
