extends Node2D
export var spawning = true
var delay = 240
var counter = 0

func _process(delta):
	counter += 1
	if counter > delay:
		if spawning:
			spawn(randi()%5)
			counter = 1

func spawn(enemint):
	var enemy = load("res://Scenes/Enemy.tscn").instance()
	enemy.position = Vector2(960,0)
	add_child(enemy)
	
