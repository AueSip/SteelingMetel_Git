extends Control


onready var health_counter = $HBoxContainer/TextureRect/HealthCount
onready var energy_counter = $HBoxContainer/TextureRect/EnergyCount

var max_health = PlayerStats.max_health
var current_health = PlayerStats.health

var max_energy = PlayerStats.max_energy
var current_energy = PlayerStats.energy

func _ready():
	health_counter.max_value == max_health
	energy_counter.max_value == max_energy

func _process(_delta):
	health_check()
	energy_check()

func health_check():
	if health_counter.value != PlayerStats.health:
		health_counter.value = PlayerStats.health
	
func energy_check():
	if energy_counter.value != PlayerStats.energy:
		energy_counter.value = PlayerStats.energy
	
