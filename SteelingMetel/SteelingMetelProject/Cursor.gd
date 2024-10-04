extends CanvasLayer

onready var cursor = $Cursor

func _ready():
	cursor.frame = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
func _process(delta):
	cursor.global_position = cursor.get_global_mouse_position()
	if (Input.is_action_just_pressed("shoot")):
		cursor.frame = 0
		$AnimationPlayer.play("Button Click")
	if (Input.is_action_just_pressed("attack")):
		$WaitTime.start()
		cursor.frame = 1
		$AnimationPlayer.play("Button Click")
		yield($WaitTime, "timeout")
		cursor.frame = 0
