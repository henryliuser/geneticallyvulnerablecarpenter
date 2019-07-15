extends "Scenes/Enemy.gd"
onready var ray = $RayCast2D
export var spd = 500
export var dip = false
var dipstance = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	orb = true
	health = 2
	speed = spd
	dipstance = position.y + 70
func _physics_process(delta):
	if position.y > dipstance and dip:
		velocity.y = -500
	elif ray.is_colliding():
		velocity.y = -500