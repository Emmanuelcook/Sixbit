extends RigidBody2D

var Smoketrail = preload("res://Player/smokeTrail.tscn")

onready var AimCast = $AimCast
onready var timer = $Timer
onready var cylinder = get_node("../../CanvasLayer/cylinder")
onready var bullet = get_node("../../bullet")
onready var godGunBullet = get_node("../../godGunBullet")
export var godGunFireRate = 5
var godGunCanShoot = true
var godGunActivated = false

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
	if Global.godGun:
		godgun()
	
	if godGunActivated && !Global.godGun:
		godgunReverse()
		
	if !Global.godGun:
		if onOil:
			$SandCollision.disabled = true
			$OilCollision.disabled = false
		else: 
			$SandCollision.disabled = false
			$OilCollision.disabled = true
	else: 
		$SandCollision.disabled = true
		$OilCollision.disabled = true
		$godGunCollision.disabled = false
	
		
	# Quand essaie de tirer
	if Input.is_action_just_pressed("click"):
		if Global.godGun: return true
		# Si on est en train de reload c'est non
		if is_reloading: return true
		
		# On enlève une balle du cylindre
		ballUsed += 1
		get_node("../..").bulletsFired += 1 # Bullets fired for the level
		
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
			
	if Input.is_action_pressed("click"):
		if Global.godGun:
			if !godGunCanShoot:
				godGunFireRate -= 1
				if godGunFireRate == 0:
					godGunCanShoot = true
					godGunFireRate = 5
				return true
			
			godGunCanShoot = false
			
			if !first_shot:
				self.gravity_scale = gravityScale
				get_parent().get_node("Start1").visible = false
				get_parent().get_node("Start2").visible = false
				# start timer on Level Node
				get_node("../..").timer(true)
				first_shot = true
			
			if AimCast.is_colliding():
				if AimCast.get_collider().is_in_group("target"):
					AimCast.get_collider().got_shot()
					
			# On enlève une balle du cylindre
			ballUsed += 1
			get_node("../..").bulletsFired += 1 # Bullets fired for the level
			
			# Drawing Shot
			draw_shot()
			$shot.play()
			recoil()
			godGunBullet.emit(true) 
			get_parent().get_node("Anchor/Cam").add_trauma(0.1)
	else:
		if Global.godGun:
			godGunBullet.emit(false) 
		

func godgun():
	if !godGunActivated:
		force = 150
		$Sprite.visible = false
		$godGunSprite.visible = true
		cylinder.visible = false
		$godGun.play()
		godGunActivated = true
		$godGunParticles.emitting = true

func godgunReverse():
	ballUsed = 0
	force = 1500
	$Sprite.visible = true
	$godGunSprite.visible = false
	cylinder.visible = true
	$godGunReverse.play()
	godGunActivated = false
	$godGunParticles.emitting = true
	
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

	# Effet de recul adoucit qu'on remet rapidement
	if !Global.godGun:
		self.linear_damp = 8
	else:
		self.linear_damp = 2
		
	$resetdamp.start()

func reset_damp():
	self.linear_damp = -1
	$resetdamp.stop()


func _on_OilDetect_body_entered(body):
	if body.is_in_group('slippy'):
		onOil = true
		if !Global.godGun:
			if self.linear_damp == 8:
				self.linear_damp = 6


