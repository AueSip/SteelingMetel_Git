extends CanvasLayer


var bulletExplosion = preload("res://Resources/Materials/BulletExplosion_Mat.tres")
var MuzzleParticle = preload("res://Resources/Materials/MuzzleParticle_Mat.tres")
var Shrapnel = preload("res://Resources/Materials/Shrapnel_Mat.tres")
var WheelParticle = preload("res://Resources/Materials/WheelParticle_Mat.tres")

var materials = [
bulletExplosion, 
MuzzleParticle, 
Shrapnel, 
WheelParticle
]

var frames = 0
var loaded = false

func _ready():
	for material in materials:
		var particles_instance = Particles2D.new()
		particles_instance.set_process_material(material)
		particles_instance.set_one_shot(true)
		particles_instance.set_modulate(Color(1,1,1,0))
		particles_instance.set_emitting(true)
		self.add_child(particles_instance)

func _physics_process(_delta):
	if frames >= 3:
		set_physics_process(false)
		loaded = true
	frames += 1
