extends KinematicBody2D

var canSpawn = true
var explosion = preload("res://Particles/BulletParticle.tscn")
var velocity = Vector2(0, 0)
export var speed = 250

func _ready():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play("default")
func _physics_process(delta):
	
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	if collision_info != null:
		muzzle_particle_spawn()
		queue_free()

func _on_Hitbox_area_entered(_area):
	muzzle_particle_spawn()
	queue_free()

func muzzle_particle_spawn():
	if canSpawn == true:
		var explosive = explosion.instance()
		get_parent().add_child(explosive)
		explosive.position = $ParticleSpawn.global_position
		canSpawn = false


