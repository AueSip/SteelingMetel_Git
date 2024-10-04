extends KinematicBody2D


enum State {NORMAL, ATTACK}

export(bool) var recieves_knockback: bool = true
export(float) var knockback_modifier: float = 0.1

const invincibility_duration = 1.5
const muzzleParticle = preload("res://Particles/MuzzleParticle.tscn")
const wheelParticle = preload("res://Particles/WheelParticle.tscn")
const bulletPath = preload("res://Player/Bullet.tscn")
const bulletParticle = preload("res://Particles/BulletParticle.tscn")

onready var movementTimer = $MovementDisableTimer
onready var gunAnim = $Position2D/GunAnim
onready var blinker = $Blinker
onready var hurtbox = $Hurtbox
onready var animPlayer = $AnimationPlayer
onready var hHurtbox = $Hurtbox/HeadHurtbox
onready var bHurtbox = $Hurtbox/BodyHurtbox
onready var shotTimer = $ShotTimer
onready var coyoteTimer = $CoyoteTimer
onready var trajectory = $Position2D/Trajectory
onready var bulletSpawn = $"Position2D/Bullet Spawn"
onready var playerSprite = $SpriteAxis/AnimatedSprite
onready var gun = $Position2D/Gun
onready var gunSwivel = $Position2D

var hitTarget = false
var movementinput = true
var is_invincible = false
var canPunch = true
var hasEnergy = true
var smoothedMousePos: Vector2
var attackSwing = 1
var state = State.NORMAL
var armsHorizontalSpeed = 160
var bodyHorizontalSpeed = 145
var upgradeLevel = 0
var gravity = 1500
var up = Vector2.UP
var velocity = Vector2.ZERO
var maxHorizontalSpeed = 105
var jumpSpeed = 485
var horizontalAcceleration = 2000
var jumpTerminationMultiplier = 4
var currentState = State.NORMAL
var isStateNew = false
var hasBody = false
var hasArms = false
var hasBlaster = false
var unStuck = true
var knockback = Vector2.ZERO
var dir = 1
var coyoteJump = false

func _ready():
	playerSprite.rotation_degrees = 0
	gun.visible = false
	$Hitbox.monitorable = false
	$Hitbox.monitoring = false
	
func _process(delta):
	
	if gunSwivel.rotation_degrees == 360:
		gunSwivel.rotation_degrees = 0
	if gunSwivel.rotation_degrees == -360:
		gunSwivel.rotation_degrees = 0

	
	
	match currentState:
		State.NORMAL:
			process_normal(delta)
		State.ATTACK:
			process_attack(delta)
	
	color_change()
	recieve_knockback(delta)
	rotateZero()
	has_energy()
	smoothed_mouse_pos()
	gun_rotate()
	gun_flip()
	upgrade()
	
	
func change_state(newState):
	currentState = newState	
	isStateNew = true
			
func process_normal(delta):
	if (isStateNew):
		$Hitbox.monitorable = false
		$Hitbox.monitoring = false
	movement_input(delta)
		
	spawn_wheel_particle()
	

	if (hasArms == true && Input.is_action_just_pressed("attack")):
		canPunch = true
		call_deferred("change_state", State.ATTACK)
		

	update_animation()

func process_attack(delta):
	$Hitbox.monitorable = true
	$Hitbox.monitoring = true
	movement_input(delta)
	spawn_wheel_particle()
	if playerSprite.flip_h == true:
		punch_left_side()

	elif playerSprite.flip_h == false:
		punch_right_side()
	
	canPunch = false
	
func color_change():
	if PlayerStats.can_be_pink == true:
		playerSprite.modulate = Color8(239, 172, 255, 255)
			
func get_movement_vector():
		var moveVector = Vector2.ZERO
		if movementinput == true:
			moveVector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
			moveVector.y = -1 if Input.is_action_just_pressed("jump") else 0
		return moveVector

func movement_input(delta):
	
	var moveVector = get_movement_vector()
	var wasOnFloor = is_on_floor()
	
	if Input.is_action_pressed("jump"):
		coyoteJump = false
	
	velocity = move_and_slide(velocity, up)
	
	if is_on_floor():
		coyoteJump = true
	
	if !is_on_floor() && coyoteJump == true:
		if coyoteTimer.is_stopped():
			$CoyoteTimer.start()
			coyoteJump = false
	
	velocity.x += moveVector.x * horizontalAcceleration * delta
	if (moveVector.x == 0):
		velocity.x = lerp(0, velocity.x, pow(2, -50 * delta))
	
	velocity.x = clamp(velocity.x, -maxHorizontalSpeed, maxHorizontalSpeed)
	
	if hasBody == true:
		if (moveVector.y < 0 && (!coyoteTimer.is_stopped() || is_on_floor())):
			velocity.y = moveVector.y * jumpSpeed
			coyoteTimer.stop()
		
	
		
	if (velocity.y < 0 && !Input.is_action_pressed("jump")):
		velocity.y = moveVector.y * jumpSpeed * jumpTerminationMultiplier * delta
	else:
		velocity.y += gravity * delta
	
func _unhandled_input(_event):
	if Input.get_action_strength("move_right") && hasBody == false:
		pass
	if Input.get_action_strength("move_left") && hasBody == false:
		pass
	if Input.is_action_just_pressed("shoot"):
		shoot()


func update_animation():
	var moveVec = get_movement_vector()
	
	if upgradeLevel == 0:
		if moveVec.x > 0:
			playerSprite.play("head")
			animPlayer.play("Roll Right")
		elif moveVec.x < 0:
			animPlayer.play("Roll Left")
		else:
			animPlayer.play("HeadReset")
			
	if upgradeLevel == 1:
		animPlayer.stop()
		$SpriteAxis.position.y = -3.5
		$SpriteAxis.rotation_degrees = 0
		if (!is_on_floor() && velocity.x != 0):
			animPlayer.stop()
			playerSprite.play("B_Jump")
		elif (moveVec.x != 0):
			playerSprite.play("B_Run")
		else:
			playerSprite.play("B_Idle")
	if upgradeLevel == 2:
		if (!is_on_floor() && velocity.x != 0):
			playerSprite.play("A_Jump")
		elif (moveVec.x != 0):
			playerSprite.play("A_Run")
		else:
			playerSprite.play("A_Idle")
	if upgradeLevel == 3:
		if (!is_on_floor() && velocity.x != 0):
			playerSprite.play("Max_Jump")
		elif (moveVec.x != 0):
			playerSprite.play("Max_Run")
		else:
			playerSprite.play("Max_Idle")
				
	if (moveVec.x != 0):
		playerSprite.flip_h = true if moveVec.x < 0 else false
	if (moveVec.x <= 0) && playerSprite.flip_h == true:
		playerSprite.offset.x = -6 
		$MeleePos.position.x = -18
	else:
		playerSprite.offset.x = 0
		$MeleePos.position.x = 18
func upgrade():
	if upgradeLevel == 0:
		playerSprite.play("head")
	if upgradeLevel == 1:
		hHurtbox.set_disabled(true)
		bHurtbox.set_disabled(false)
		$HeadCollision.set_disabled(true)
		$BodyCollision.set_disabled(false)
		maxHorizontalSpeed = bodyHorizontalSpeed
		hasBody = true
		move_position()
	if upgradeLevel == 2:
		maxHorizontalSpeed = armsHorizontalSpeed
		hasArms = true
	if upgradeLevel == 3:
		gun.visible = true
		hasBlaster = true
		
func move_position():
	if (hasBody == true) && (unStuck == true): 
		self.position.y -=15
		unStuck = false

func rotateZero():
	if hasBody == true && rotation_degrees != 0:
		rotation_degrees = 0

func _on_UpgradeLook_area_entered(_area):
	if _area.is_in_group("upgrade"):
		upgradeLevel +=1
		print (upgradeLevel)


func switch_state():
	if attackSwing == 0:
		attackSwing = 1
		print("1")
	elif attackSwing == 1:
		attackSwing = 0
		print("0")
	call_deferred("change_state", State.NORMAL)
	
func gun_rotate():
	gunSwivel.look_at(smoothedMousePos)
	clamp_rotation()
	
func smoothed_mouse_pos():
	smoothedMousePos = lerp(smoothedMousePos, get_global_mouse_position(), 0.5)

func shoot():
	if hasBlaster == true && hasEnergy == true && shotTimer.is_stopped():
		gunAnim.play("Gun Shot")
		muzzle_particle()
		_bullet()
		shotTimer.start()
		PlayerStats.energy -=1
		PlayerStats.energyTimer.start()

		
func gun_flip():	
	if gunSwivel.rotation_degrees >= 90 && gunSwivel.rotation_degrees <= 270 || gunSwivel.rotation_degrees <= -90 && gunSwivel.rotation_degrees >= -270:
		gun.flip_v = true
		gun.position.y = .5
	else:
		gun.position.y = -.5
		gun.flip_v = false
		
func clamp_rotation():
	gunSwivel.set_rotation_degrees(max(min(360,gunSwivel.get_rotation_degrees()),-360))

func _bullet():
	var bullet = bulletPath.instance()
	get_parent().add_child(bullet)
	bullet.position = bulletSpawn.global_position
	bullet.rotation_degrees = gunSwivel.rotation_degrees
	bullet.velocity = trajectory.get_global_position() - bullet.position

func has_energy():
	if PlayerStats.energy >0:
		hasEnergy = true
	else:
		hasEnergy = false


func _on_Hurtbox_area_entered(area):
	if !is_invincible:
		knockback = Vector2.RIGHT * knockback_modifier * dir
		movementinput = false
		movementTimer.start()
		PlayerStats.health -= area.damage
		blinker.start_blinking(self, invincibility_duration)
		start_invincibility()
		
func _on_MovementDisableTimer_timeout():	
	movementinput = true
	
func spawn_wheel_particle():
	
	var moveVec = get_movement_vector()
	
	if (moveVec.x != 0) && hasBody == true && is_on_floor():
		var wheelstep = wheelParticle.instance()
		get_parent().add_child(wheelstep)
		wheelstep.global_position = global_position
		wheelstep.position.y += 8
		if playerSprite.flip_h == true: 
			wheelstep.scale.x = -1 
		else:
			wheelstep.scale.x = 1
			
func muzzle_particle():
	var muzzle = muzzleParticle.instance()
	get_parent().add_child(muzzle)
	muzzle.position = bulletSpawn.global_position
	muzzle.rotation_degrees = gunSwivel.rotation_degrees

func punch_right_side():
	if (isStateNew) && attackSwing == 1 && canPunch == true:
			if hasBlaster == true:
				animPlayer.play("MaxPunchRH")
			else:
				animPlayer.play("PunchRH")
		
			
	if (isStateNew) && attackSwing == 0 && canPunch == true:
		if hasBlaster == true:
			animPlayer.play("MaxPunchLH ")
		else:
			animPlayer.play("PunchLH")
				
func punch_left_side():
	if (isStateNew) && attackSwing == 1 && canPunch == true:
		if hasBlaster == true:
			animPlayer.play("MaxPunchRHLeftSide")
				
		else:
			animPlayer.play("PunchRHLeftSide")
				
	if (isStateNew) && attackSwing == 0 && canPunch == true:
		if hasBlaster == true:
			animPlayer.play("MaxPunchLHLeftSide")
		else:
			animPlayer.play("PunchLHLeftSide")

func start_invincibility():
	is_invincible = true
	if is_invincible == true:
		hurtbox.set_deferred("monitoring", false)
		hurtbox.set_deferred("monitorable", false)
		yield(get_tree().create_timer(invincibility_duration), "timeout")
		hurtbox.set_deferred("monitoring", true)
		hurtbox.set_deferred("monitorable", true)
		is_invincible = false
func recieve_knockback(delta):
	if recieves_knockback:
		knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
		knockback = move_and_slide(knockback)

func _on_LeftAttackDir_area_entered(_area):
	dir = 1
	
func _on_RightAttackDir_area_entered(_area):
	dir = -1

func melee_spawn():
	if hitTarget == true:
		var meleehit = bulletParticle.instance()
		get_parent().add_child(meleehit)
		meleehit.position = $MeleePos.global_position
		meleehit.scale.x = .4
		meleehit.scale.y = .4
		hitTarget = false


func _on_Hitbox_area_entered(area):
	hitTarget = true
	melee_spawn()
	yield()
	

	


func _on_DetectionZone_area_entered(area):
	$InteractIcon.visible = true

	
func _on_DetectionZone_area_exited(area):
	$InteractIcon.visible = false
