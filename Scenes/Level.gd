extends Node2D
export var spawning = true
export var xPos = 0
export var yPos = 0
export var spawned = "res://Scenes/Slime.tscn"
export var xDirec = 1.0
export var delay = 240
var counter = 0

func _process(delta):
	counter += 1
	if counter > delay:
		if spawning:
			spawn(randi()%5)
			counter = 1

func spawn(enemint):
	var enemy = load(spawned).instance()
	enemy.position = Vector2(xPos,yPos)
	enemy.xDirec = xDirec
	add_child(enemy)
	
