extends Node2D
export var difficulty = 5
export var functional = false
var anybody = null
var playerInRange = false
var fixing = false
var moves = ["player_left","player_right","player_jump","player_crouch","player_fix","player_attack"]
var progress = 0
var currentMove = "" 
var input = null
onready var prompt = $prompt

func _ready():
	randomize()
	currentMove = moves[randi()%6]
	
func _process(delta):
	if anybody!= null and not anybody.fixing:
		fixing = false

func _input(event):
	input = null
	if event is InputEventKey and event.pressed and fixing and anybody.fixing and not event.is_echo():
		input = event.scancode
	elif event is InputEventKey and event.pressed and fixing and anybody.fixing and event.is_echo():
		input = null
	#get_tree().set_input_as_handled() dont uncomment this its a curse
#	print(input)
#	print(Global.keyToText.get(input))
#	print("from _input")

func checkFix():
	if playerInRange:
		if not fixing and not anybody.fixing and not functional and Input.is_action_just_pressed("player_fix"):
			anybody.velocity = Vector2(0,0)
			anybody.fixing = true
			fixing = true
		elif fixing and anybody.fixing:
			fix()
		else:
			fixing = false
			anybody.fixing = false
			anybody.modulate = Color(1,1,1,1)
			prompt.play("default")
			
		
func _on_Area2D_area_entered(area): #{           //also this is for enemies
	if fixing:
		fixing = false
		Global.scrambleControls()
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

		
	

	
	
