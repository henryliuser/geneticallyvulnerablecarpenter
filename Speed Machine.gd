extends "res://Machine.gd"
onready var anim = $AnimatedSprite
var speedMultiplier = 2

func _physics_process(delta):
	checkFix()

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
		Global.speedMultiplier /= speedMultiplier
	if progress == difficulty:
		fixing = false
		anybody.fixing = false
		functional = true
		anybody.modulate = Color(1,1,1,1)
		anim.play("idle")
		prompt.play("default")
		Global.speedMultiplier *= speedMultiplier



func _on_FixRadius_body_entered(body):
	anybody = body
	playerInRange = true


func _on_FixRadius_body_exited(body):
	anybody = null
	playerInRange = false


func _on_BreakRadius_area_entered(area):
	._on_Area2D_area_entered(area)
	anim.play("dead")
	Global.speedMultiplier /= speedMultiplier
