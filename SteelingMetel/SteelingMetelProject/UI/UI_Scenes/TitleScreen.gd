extends Node

var optionsMenuScene = preload("res://UI/UI_Scenes/OptionsMenu.tscn")

var play = false
onready var time = $WaitTime

func _ready():
	play = false
	PlayerStats.max_health = 5
	Engine.set_target_fps(60)


			
func _on_Play_pressed():
	time.start()
	yield(time, "timeout")
	get_tree().change_scene("res://Scenes/Levels/Scrapyard_001.tscn")
		


func _on_Quit_pressed():
	time.start()
	yield(time, "timeout")
	get_tree().quit()


func _on_Options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	$VBoxContainer.visible = false
	
func on_options_back_pressed():
	$OptionsMenu.queue_free()
	$VBoxContainer.visible = true
	
func _on_Debug_pressed():
	time.start()
	yield(time, "timeout")
	get_tree().change_scene("res://Scenes/Levels/Main.tscn")
