extends "res://Machine.gd"
onready var anim = $AnimatedSprite

func _physics_process(delta):
	checkFix()

func _on_Area2D_body_entered(body):
	if body.has_method("startHealing"):
		if functional: 
			body.startHealing()
		anybody = body
		playerInRange = true
		
func _on_Area2D_body_exited(body):
	anybody = null
	playerInRange = false
	if body.has_method("startHealing"):
		body.stopHealing()
	
func _on_Area2D_area_entered(area): #{           //also this is for enemies
	Global.scrambleControls()
	anim.play("hurt")
	if anybody != null: anybody.stopHealing()
	functional = false
#}

