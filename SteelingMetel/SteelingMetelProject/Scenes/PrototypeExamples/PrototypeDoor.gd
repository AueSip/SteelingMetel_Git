extends Node2D

var is_interactable = false

func _physics_process(delta):
	interact()


func interact():
	if PlayerStats.prototype_key == 1 and is_interactable == true:
		if Input.is_action_just_pressed("interact"):
			$StaticBody2D/AnimatedSprite.play("default")
			$StaticBody2D/CollisionShape2D.disabled = true
			$StaticBody2D/DetectionZone.monitorable = false
			$StaticBody2D/DetectionZone.monitoring = false


func _on_DetectionZone_body_entered(body):
	is_interactable = true


func _on_DetectionZone_body_exited(body):
	is_interactable = false
