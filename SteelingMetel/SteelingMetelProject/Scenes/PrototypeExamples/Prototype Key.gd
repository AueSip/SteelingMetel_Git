extends Node2D


func _on_DetectionZone_body_entered(body):
	if body.is_in_group("player"):
		PlayerStats.prototype_key +=1
		print(PlayerStats.prototype_key)
		queue_free()
