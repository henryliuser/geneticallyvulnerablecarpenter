extends Area2D
var frameTimer = 0

func _process(delta):
	frameTimer += 1
	if frameTimer == 40:
		queue_free()
	


func _on_playerAttackHitBox_body_entered(body):
	if body.has_method("hurt"):
		body.hurt()
