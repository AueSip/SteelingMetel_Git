extends Node

export(int) var max_health = 1 setget set_max_health
export(int) var max_energy = 1 setget set_max_energy

onready var energyTimer = $EnergyRecharge
var health = max_health setget set_health
var energy = max_energy setget set_energy
var prototype_key = 0
var can_be_pink = false
var currency_collectible = 0


signal no_health
signal health_changed(value)
signal max_health_changed(value)

signal no_energy
signal energy_changed(value)
signal max_energy_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)
	
func set_max_energy(value):
	max_energy = value
	self.energy = min(energy, max_energy)
	emit_signal("max_energy_changed", max_energy)
	
	
func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_energy(value):
	energy = value
	emit_signal("energy_changed", energy)
	if energy <= 0:
		emit_signal("no_energy")

func _ready():
	self.health = max_health
	self.energy = max_energy

func _on_EnergyRecharge_timeout():
	if energy <7:
		self.energy +=1

func _process(_delta):
	if energy == 7:
		$EnergyRecharge.stop()
	if health <= 0:
		get_tree().change_scene("res://UI/UI_Scenes/TitleScreen.tscn")
		health = max_health
		energy = max_energy
		can_be_pink = false
		prototype_key = 0
	
