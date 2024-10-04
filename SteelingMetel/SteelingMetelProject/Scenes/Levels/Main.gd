extends Node


var pauseScene = preload("res://UI/UI_Scenes/PauseMenu.tscn")

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		var pauseInstance = pauseScene.instance()
		add_child(pauseInstance)
