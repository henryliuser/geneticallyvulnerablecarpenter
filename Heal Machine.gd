extends "res://Machine.gd"
onready var anim = $AnimatedSprite
onready var prompt = $prompt

func _physics_process(delta):
	checkFix()

func _on_Area2D_body_entered(body):
	if body.has_method("startHealing"):
		if functional: 
			body.startHealing()
		anybody = body
		playerInRange = true
		
func _on_Area2D_body_exited(body):
	if body.has_method("startHealing"):
		body.stopHealing()
		anybody = null
		playerInRange = false
	
func _on_Area2D_area_entered(area): #{           //also this is for enemies
	._on_Area2D_area_entered(area)
	anim.play("dead")
#}

func fix():
	prompt.play(Global.labels[Global.actions.get(currentMove)])
#	print(input)
#	print(InputMap.get_action_list(currentMove)[0])
#	print("from fix")
	if input == InputMap.get_action_list(currentMove)[0].scancode:
		progress += 1
		currentMove = moves[randi()%6]
		input = null
		anim.play("hurt")
	elif input != null:
		anybody.modulate = Color(1,1,1,1)
		progress = 0
		Global.scrambleControls()
		fixing = false
		anybody.fixing = false
		anim.play("dead")
		prompt.play("default")
	if progress == difficulty:
		fixing = false
		anybody.fixing = false
		functional = true
		anybody.modulate = Color(1,1,1,1)
		anybody.startHealing()
		anim.play("idle")
		prompt.play("default")

