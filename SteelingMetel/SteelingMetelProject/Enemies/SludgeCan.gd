extends KinematicBody2D

export(bool) var recieves_knockback: bool = true
export(float) var knockback_modifier: float = 0.1

onready var ray_left = $AnimatedSprite/LeftRay
onready var ray_right = $AnimatedSprite/RightRay
onready var stats = $Stats
onready var anim_player = $AnimationPlayer
onready var timer = $WaitTimer


var hit_duration = 0.5
var jumping = false

var hit_already = false
var knockback = Vector2.ZERO
var agro = false
var max_speed = 85
var gravity = 500
var velocity = Vector2.ZERO
var up = Vector2.UP
var direction = Vector2.ZERO
var start_direction = Vector2.LEFT
var dir = 1

func _ready():
	anim_player.play("Hidden")

func _physics_process(delta):
	recieve_knockback(delta)
	velocity.y += gravity * delta
	raycollide()
	
	velocity = move_and_slide(velocity, up)
	
	if $AnimatedSprite.position.y < -25 && jumping == true:
		velocity.x = (direction * max_speed).x
	else:
		velocity.x = 0
	
	if stats.health <= 0:
		queue_free()
	
	
	$AnimatedSprite.flip_h = true if direction.x > 0 else false
	
func _on_DetectionZone_body_entered(body):
	if body.is_in_group("player"):
		anim_player.play("Active")
		timer.start()
		
func _on_WaitTimer_timeout():
	if agro == true:
		anim_player.play("InAir")
		jumping = true
		agro = false
	else:
		anim_player.play("JumpBegin")
		timer.start()
	
func _on_GoalDetection_area_entered(area):
	print("entered")
	direction *= -1;

func agroed():
	agro = true
	print(agro)

func looping_movement():
	jumping = false
	anim_player.play("Active")
	timer.start()

func _on_Hurtbox_area_entered(area):
	if !hit_already:
		knockback = Vector2.RIGHT * knockback_modifier * dir
		stats.health -= area.damage
		return direction
		print(stats.health)
		is_just_hit()
		
func raycollide():
	if ray_right.is_colliding():
		direction.x = 1
	if ray_left.is_colliding():
		direction.x = -1
	
	if $AnimatedSprite/LeftAttackDir.is_colliding():
		dir = 1
	if $AnimatedSprite/RightAttackDir.is_colliding():
		dir = -1
		
func recieve_knockback(delta):
	if recieves_knockback:
		knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
		knockback = move_and_slide(knockback)
		
		
func is_just_hit():
	hit_already = true
	if hit_already == true:
		yield(get_tree().create_timer(hit_duration), "timeout")
		hit_already = false





