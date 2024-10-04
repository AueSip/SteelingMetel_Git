extends Button


onready var hover = $HoverAnimPlayer
onready var click = $ClickAnimPlayer

func _ready():
	pass



func _on_Button_mouse_entered():
	hover.play("Hover")


func _on_Button_mouse_exited():
	hover.play_backwards("Hover")


func _on_Button_pressed():
	click.play("Click")
