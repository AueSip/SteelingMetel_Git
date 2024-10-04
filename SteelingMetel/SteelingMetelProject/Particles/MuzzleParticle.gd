extends Node2D

func _ready():
	$MuzzlePos/MuzzleParticle.emitting = true
	$AnimationPlayer.play("delete")
