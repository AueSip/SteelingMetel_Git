extends Node2D


func _on_DetectionZone_body_entered(body):
	if body.is_in_group("player"):
		PlayerStats.currency_collectible +=1
		print(PlayerStats.currency_collectible)
		$CoinMovement.play("Collect")
	
