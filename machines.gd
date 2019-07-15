extends Node2D
var counter = 0
export var filepath = "res://"

# Called when the node enters the scene tree for the first time.
func _process(delta):
	counter += 1
	if counter > 60:
		counter = 0
		var numFunc = 0
		for x in get_children():
			if x.functional:
				numFunc += 1
		if numFunc == get_child_count():
			Global.resetControls()
			get_tree().change_scene(filepath)
		if numFunc > get_child_count()/2:
			Global.resetControls()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
