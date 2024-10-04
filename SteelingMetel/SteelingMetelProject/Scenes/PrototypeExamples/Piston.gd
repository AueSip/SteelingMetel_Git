extends Node2D

export var timer = 0

onready var time_wait = $Timer

func _ready():
	yield(get_tree().create_timer(timer), "timeout")
	$AnimationPlayer.play("Slam")
