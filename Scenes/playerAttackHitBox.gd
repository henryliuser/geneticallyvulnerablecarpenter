extends Area2D
var frameTimer = 0
var velocity = 400

func _process(delta):
	frameTimer += 1
	if frameTimer == 6:
		queue_free()
	

func _on_playerAttackHitBox_body_entered(body):
	if body.has_method("hurtWrench"):
		body.hurtWrench(velocity)
