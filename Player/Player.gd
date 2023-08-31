extends RigidBody2D

var Smoketrail = preload("res://Player/Effects/smokeTrail.tscn")
var bulletParticle = preload("res://Player/Effects/bulletParticles.tscn")
var AimCastRicochet = preload("res://Player/AimCastRicochet.tscn")
var ricochetParticles = preload("res://Player/Effects/ricochetParticles.tscn")

onready var AimCast = $AimCast
onready var timer = $Timer
onready var level = self.get_parent().get_parent()
onready var cylinder = level.get_node("CanvasLayer/cylinder")
onready var bullet = level.get_node("bullet")
onready var godGunBullet = level.get_node("godGunBullet")
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

var ricochetVisible = false
var finishLevelNextFrame = false

func _ready():
	self.gravity_scale = 0
	
	$resetdamp.connect("timeout", self, "reset_damp")
	$resetdamp.set_wait_time(0.2)

func _process(delta):
	if ricochetVisible:
		# ici il faut faire plus tous les ricochets se desactive ou quoi
		# ----------------------------------
		# ATTENTION
		for ricochet in level.get_node("Ricochets").get_children():
			ricochet.get_node('ricochetFlash').visible = false
	
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
		
		if finishLevelNextFrame: return true
		if get_parent().get_parent().levelIsFinished: finishLevelNextFrame = true
		
		
		# On enlève une balle du cylindre
		ballUsed += 1
		get_node("../..").addOneBulletsFired() # Bullets fired for the level
		
		
		# Sinon on tire
		$shot.play()
		$bulletout.play()
		recoil()
		cylinder.shot(ballUsed)
		
		# particle bullet
#		bullet.emitOne() 
		var bulletP = bulletParticle.instance()
		get_parent().get_parent().add_child(bulletP)
		bulletP.global_position = global_position
		bulletP.restart()
		get_tree().create_timer(bulletP.lifetime,false).connect("timeout", bulletP, "queue_free")
		
		# Si c'est la premiere fois
		# On remet la gravité et on enleve les effets du rond au début
		if !first_shot:
			Global.fullResetInput = 0
			
			if Global.currentLevel == 1:
				Global.SRtimerState = true
				
			self.gravity_scale = gravityScale
			get_parent().get_node("Start1").visible = false
			get_parent().get_node("Start2").visible = false
			
			# start timer on Level Node
			get_node("../..").timer(true)
			first_shot = true
		
		# On check avec quoi on collide, si c'est une target, on le got shot
		if AimCast.is_colliding():
			if AimCast.get_collider().is_in_group("target"):
				
				eclat(AimCast, AimCast.global_transform.origin, AimCast.get_collision_point())
				AimCast.get_collider().got_shot()
		
		if AimCast.is_colliding():
			if AimCast.get_collider().is_in_group("ricochet"):
				var collider = AimCast.get_collider()
				eclat(AimCast, AimCast.global_transform.origin, AimCast.get_collision_point())
				ricochet(AimCast, collider)
				
				
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
			get_node("../..").addOneBulletsFired() # Bullets fired for the level
			
			# Drawing Shot
			draw_shot()
			$shot.play()
			recoil()
			godGunBullet.emit(true) 
			get_parent().get_node("Anchor/Cam").add_trauma(0.1)
	else:
		if Global.godGun:
			godGunBullet.emit(false) 
		
func eclat(raycast, startingPoint, collisionPoint):
	var eclat = ricochetParticles.instance()
	get_parent().get_parent().add_child(eclat)
	eclat.global_position = collisionPoint
	eclat.rotation = (collisionPoint - startingPoint).angle()
	eclat.emitting = true
	
func ricochet(raycast, collider):
	collider.get_node("metalHit").play()

	#Info about first shot
	var BulletStart = raycast.global_transform.origin
	var collisionPoint = raycast.get_collision_point()
	var normal = raycast.get_collision_normal()
	var incoming_direction = collisionPoint - BulletStart

	collider.get_node("ricochetFlash").visible = true

	ricochetVisible = true
	
	# Info about ricochet
	var outgoing_direction = incoming_direction.bounce(normal)
	var outgoing_length = 50.0 # Arbitrary
	
	# Decalage de 1 pour que le raycast ne se prenne pas uen fois sur deux dans le collider ricochet

	var newPoint = collisionPoint + outgoing_direction.clamped(1)

	# Instance a new raycast
	var newCast = AimCastRicochet.instance()
	get_parent().get_parent().add_child(newCast)

	# position of the new raycast
	newCast.global_position = newPoint
	newCast.set_cast_to(outgoing_direction * outgoing_length)
	newCast.force_raycast_update()
	
	var ricochetCollider = outgoing_direction * outgoing_length
	
	if newCast.is_colliding():
		ricochetCollider = newCast.get_collision_point()
		
		if newCast.get_collider().is_in_group("target"):
			yield(get_tree().create_timer(0.1), "timeout")
			eclat(newCast, newCast.global_transform.origin, newCast.get_collision_point())
			newCast.get_collider().got_shot()
		
		if newCast.is_colliding():
			if newCast.get_collider().is_in_group("ricochet"):
				yield(get_tree().create_timer(0.1), "timeout")
				
				var collider2 = newCast.get_collider()
				eclat(newCast, newCast.global_transform.origin, newCast.get_collision_point())
				ricochet(newCast, collider2)

	draw_ricochet(newPoint, ricochetCollider)
#	get_tree().paused = true
	newCast.queue_free()

	
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

func draw_ricochet(from, to):
		
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




func _on_OilDetect_body_exited(body):
	if body.is_in_group('slippy'):
		onOil = false
