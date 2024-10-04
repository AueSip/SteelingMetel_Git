extends StaticBody2D

export var timer = 0

onready var anim_player = $AnimationPlayer
var knockback_dir
var dir = 1
var knockback


func _ready():
	yield(get_tree().create_timer(timer), "timeout")
	anim_player.play("Idle")
func attack():
	anim_player.play("Attack")
	
func cooldown():
	anim_player.play("Cooldown")
	
func idle():
	anim_player.play("Idle")
	
	

	
