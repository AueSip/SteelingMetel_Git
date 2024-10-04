extends Node2D



func _on_DetectionZone_body_entered(body):
	if body.is_in_group("player"):
		if PlayerStats.health != PlayerStats.max_health:
			PlayerStats.health +=1
			$AnimationPlayer.play("Collected")
		else:
			pass
