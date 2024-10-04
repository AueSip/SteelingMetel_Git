extends Node2D


func _on_DetectionZone_body_entered(body):
	if body.is_in_group("player"):
		PlayerStats.can_be_pink = true
		queue_free()
