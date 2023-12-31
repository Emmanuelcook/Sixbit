extends RigidBody2D

var Smoketrail = preload("res://Player/Effects/smokeTrail.tscn")
var bulletParticle = preload("res://UI/Howto/bulletParticleshowto.tscn")

onready var AimCast = $AimCast
onready var cylinder = get_node("../CanvasLayer/cylinder")
onready var timer = $Timer

export var force = 1500
export var gravityScale = 2

var direction
var velocity
var first_shot = false

var currentDirection
var ballUsed = 0

var is_reloading = false
var onOil

func _ready():
	self.gravity_scale = 0
	
	$resetdamp.connect("timeout", self, "reset_damp")
	$resetdamp.set_wait_time(0.2)

func _process(delta):
	
	$SandCollision.disabled = false
	$OilCollision.disabled = true

	
		
	# Quand essaie de tirer
	if Input.is_action_just_pressed("click"):

		# Si on est en train de reload c'est non
		if is_reloading: return true
		
		# On enlève une balle du cylindre
		ballUsed += 1
#		get_node("../..").addOneBulletsFired() # Bullets fired for the level
		
		# Sinon on tire
		$shot.play()
		$bulletout.play()
		recoil()
		cylinder.shot(ballUsed)

		var bulletP = bulletParticle.instance()
		get_parent().add_child(bulletP)
		bulletP.global_position = global_position
		bulletP.restart()
		get_tree().create_timer(bulletP.lifetime,false).connect("timeout", bulletP, "queue_free")
		
		# Si c'est la premiere fois
		# On remet la gravité et on enleve les effets du rond au début
		if !first_shot:
			self.gravity_scale = gravityScale
			get_parent().get_node("Start1").visible = false
			# start timer on Level Node
			first_shot = true
		
		# On check avec quoi on collide, si c'est une target, on le got shot
		if AimCast.is_colliding():
			if AimCast.get_collider().is_in_group("target"):
				AimCast.get_collider().got_shot()
		
		# Drawing Shot
		draw_shot()
#		get_parent().get_node("Anchor/Cam").add_trauma(0.3)
	
		# Si on a plus de balles on reload
		if ballUsed == 6:
			reload()

func draw_shot():
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
	
	is_reloading = true
	timer.connect("timeout", self, "end_reload")
	timer.set_wait_time(2)
	timer.start()
	
	cylinder.reload()
	
#	yield(get_tree().create_timer(.5), "timeout")
	$spin.play()

	
func end_reload():
	
	ballUsed = 0
	cylinder.end_reload()	
	is_reloading = false

func _integrate_forces(_state):
	set_angular_velocity((get_angle_to(get_global_mouse_position())) * -((get_angle_to(get_global_mouse_position())) -3.14) * 5)

func recoil():
	direction = self.global_position.direction_to(get_global_mouse_position())
	
	currentDirection = direction
	var impulse = -direction * force
	apply_central_impulse(impulse)

	self.linear_damp = 8
		
	$resetdamp.start()

func reset_damp():
	self.linear_damp = -1

	$resetdamp.stop()

