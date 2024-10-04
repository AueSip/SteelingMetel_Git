extends CanvasLayer

onready var continueButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Continue
onready var optionsButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Options
onready var quitButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Quit
var optionsMenuScene = preload("res://UI/UI_Scenes/OptionsMenu.tscn")
var titleScreen = preload("res://UI/UI_Scenes/TitleScreen.tscn")

func _ready():
	get_tree().paused = true

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		unpause()
		get_tree().set_input_as_handled()
		
func unpause():
	queue_free()
	get_tree().paused = false
	


func _on_Continue_pressed():
	unpause()
	



func _on_Options_pressed():
	var optionsMenuInstance = optionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed", self, "on_options_back_pressed")
	$MarginContainer.visible = false

	
func on_options_back_pressed():
	$OptionsMenu.queue_free()
	$MarginContainer.visible = true


func _on_Quit_pressed():
	get_tree().change_scene("res://UI/UI_Scenes/TitleScreen.tscn")
	unpause()
