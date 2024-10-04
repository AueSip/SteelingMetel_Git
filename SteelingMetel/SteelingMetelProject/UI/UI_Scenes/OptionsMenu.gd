extends CanvasLayer

signal back_pressed

onready var backButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/Back
onready var windowButton = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Window_Mode

var fullscreen = OS.window_fullscreen

func _process(delta):
	update_display()

func ready():
	update_display()

func update_display():
	windowButton.text = "Windowed" if !fullscreen else "Fullscreen"


func _on_Window_Mode_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()



func _on_Back_pressed():
	emit_signal("back_pressed")
