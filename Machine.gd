extends Node2D
export var difficulty = 5
var functional = true
var anybody = null
var playerInRange = false
var fixing = false
var moves = ["player_left","player_right","player_jump","player_crouch","player_fix","player_attack"]
var progress = 0
var currentMove = moves[randi()%6]
var input = null

func _input(event):
	input = null
	if event is InputEventKey and event.pressed and fixing and anybody.fixing and not event.is_echo():
		input = event.scancode
	elif event is InputEventKey and event.pressed and fixing and anybody.fixing and event.is_echo():
		input = null
	get_tree().set_input_as_handled()
#	print(input)
#	print(Global.keyToText.get(input))
#	print("from _input")

func checkFix():
	if playerInRange:
		if Input.is_action_just_pressed("player_fix") and not fixing and not anybody.fixing and not functional:
			print("start fixing")
			anybody.modulate = Color(0,1,0)
			anybody.fixing = true
			fixing = true
		elif fixing and anybody.fixing:
			fix()
		else:
			fixing = false
			anybody.fixing = false
		
func _on_Area2D_area_entered(area): #{           //also this is for enemies
	if functional:
		Global.scrambleControls()
		functional = false
#}

func fix():
	print(currentMove)
#	print(input)
#	print(InputMap.get_action_list(currentMove)[0])
#	print("from fix")
	if input == InputMap.get_action_list(currentMove)[0].scancode:
		progress += 1
		currentMove = moves[randi()%6]
		input = null
	elif input != null:
		anybody.modulate = Color(1,1,1,1)
		progress = 0
		Global.scrambleControls()
		fixing = false
		anybody.fixing = false
	if progress == difficulty:
		fixing = false
		anybody.fixing = false
		functional = true
		anybody.modulate = Color(1,1,1,1)

		
	

	
	
