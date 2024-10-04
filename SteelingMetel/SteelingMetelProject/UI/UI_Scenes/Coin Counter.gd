extends TextureRect



func _ready():
	update_display()
	
	
func update_display():
	if $CoinLabel.text != str(PlayerStats.currency_collectible):
		$CoinLabel.text = str(PlayerStats.currency_collectible)
		
func _process(delta):
	update_display()
	
	
