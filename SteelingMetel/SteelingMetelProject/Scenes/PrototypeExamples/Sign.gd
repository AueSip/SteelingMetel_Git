extends Node2D

export var flip_horizontal = false

export(String, MULTILINE) var text

func _ready():
	$Sprite.flip_h = flip_horizontal
	$Position/PanelContainer/MarginContainer/Label.text = text
	$Position/PanelContainer.visible = false
	
func _on_DetectionZone_body_entered(body):
	$Position/PanelContainer.visible = true
	$AnimationPlayer.play("Entered")
	


func _on_DetectionZone_body_exited(body):
	$Position/PanelContainer.visible = false
	$AnimationPlayer.play("Stop")
