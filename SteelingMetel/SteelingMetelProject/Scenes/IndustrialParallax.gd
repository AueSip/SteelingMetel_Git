extends ParallaxBackground

onready var cloud1 = $Clouds1
onready var cloud2 = $Clouds2
onready var cloud3 = $Clouds3


func _process(delta):
	cloud1.motion_offset.x += -20 * delta
	cloud2.motion_offset.x += -8 * delta
	cloud3.motion_offset.x += -5 * delta
