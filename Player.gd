extends RigidBody2D

var Smoketrail = preload("res://smokeTrail.tscn")

onready var AimCast = $AimCast
onready var timer = $Timer
onready var cylinder = get_node("../../CanvasLayer/cylinder")
onready var bullet = get_node("../../bullet")

export var force = 1500
export var gravityScale = 2

var direction
var velocity
var first_shot = false

var currentDirection
var ballUsed = 0

var is_reloading = false

func _ready():
	self.gravity_scale = 0

func _process(delta):
	
	# Quand essaie de tirer
	if Input.is_action_just_pressed("click"):

#		print(Global.is_reloading)
		
		# Si on est en train de reload c'est non
		if is_reloading: return true
		
		# On enlève une balle du cylindre
		ballUsed += 1
		get_node("../..").bulletsFired += 1 # Bullets fired for the level
#		print(ballUsed)
		
		# Sinon on tire
		$shot.play()
		$bulletout.play()
		recoil()
		cylinder.shot(ballUsed)
		
		# particle bullet
		bullet.emitOne() 
		
		# Si c'est la premiere fois
		# On remet la gravité et on enleve les effets du rond au début
		if !first_shot:
			self.gravity_scale = gravityScale
			get_parent().get_node("Start1").visible = false
			get_parent().get_node("Start2").visible = false
			
			# start timer on Level Node
			get_node("../..").timer(true)
			first_shot = true
		
		# On check avec quoi on collide, si c'est une target, on le got shot
		if AimCast.is_colliding():
			if AimCast.get_collider().is_in_group("target"):
				AimCast.get_collider().got_shot()
		
		#Screen shake
		get_parent().get_node("Anchor/Cam").add_trauma(0.3)
		
		# Drawing Shot
		draw_shot()
		
		# Si on a plus de balles on reload
		if ballUsed == 6:
			reload()
			
			

func draw_shot():
#	print("player-DrawShot")
	# always draw from the gun
	var from = $BulletPoint.global_position
	var to = get_global_mouse_position()
	
	if AimCast.is_colliding():
		to = AimCast.get_collision_point()
		
	var trail = Smoketrail.instance()
	get_parent().get_parent().add_child(trail)
	trail.add_point(from)
	trail.add_point(to)

func reload():
#	print("player-reload")
	
	is_reloading = true
	timer.connect("timeout", self, "end_reload")
	timer.set_wait_time(2.5)
	timer.start()
	
	cylinder.reload()
	
#	yield(get_tree().create_timer(.5), "timeout")
	$spin.play()
	
func end_reload():
#	print("player-endreload")
	
	ballUsed = 0
	cylinder.end_reload()	
	is_reloading = false
	
func _integrate_forces(state):
	set_angular_velocity((get_angle_to(get_global_mouse_position())) * -((get_angle_to(get_global_mouse_position())) -3.14) * 5)

func recoil():
#	print("player-recoil")
	direction = self.global_position.direction_to(get_global_mouse_position())
	
	currentDirection = direction
	var impulse = -direction * force
	apply_central_impulse(impulse)

	# Effet de recul adoucit qu'on remet rapidement
	self.linear_damp = 8
	$resetdamp.connect("timeout", self, "reset_damp")
	$resetdamp.set_wait_time(0.2)
	$resetdamp.start()

func reset_damp():
#	print("player-reset_damp")
	self.linear_damp = -1
	$resetdamp.stop()

