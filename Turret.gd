extends StaticBody2D
export var delay = 60
export var burst = 1

var timer = 0
var burstCount = 0

var lazarus

func _ready():
	lazarus = get_node("Lazors")

func _process(delta):
	timer += 1
	if burst != 1:
		if timer%5 == 0 and burstCount < burst:
			shoot()
			burstCount += 1
	if timer > delay:
		shoot()
		timer = 0
		burstCount = 0

func shoot():
	var lazer = load("res://Scenes/lazer.tscn").instance()
	lazarus.add_child(lazer)