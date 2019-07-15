extends "res://Machine.gd"
export var delay = 60
export var burst = 1
onready var anim = $AnimatedSprite

var timer = 0
var burstCount = 0

var lazarus

func _ready():
	lazarus = get_node("Lazors")

func _process(delta):
	timer += 1
	if burst != 1:
		if timer%5 == 0 and burstCount < burst-1:
			shoot()
			burstCount += 1
	if timer > delay:
		shoot()
		timer = 0
		burstCount = 0

func shoot():
	var lazer = load("res://Scenes/lazer.tscn").instance()
	lazer.position = Vector2(0,-15)
	lazarus.add_child(lazer)
	
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
	if progress == difficulty:
		fixing = false
		anybody.fixing = false
		functional = true
		anybody.modulate = Color(1,1,1,1)
		anim.play("idle")
		prompt.play("default")



func _on_FixRadius_body_entered(body):
	anybody = body
	playerInRange = true


func _on_FixRadius_body_exited(body):
	anybody = null
	playerInRange = false


func _on_BreakRadius_area_entered(area):
	._on_Area2D_area_entered(area)
	anim.play("dead")