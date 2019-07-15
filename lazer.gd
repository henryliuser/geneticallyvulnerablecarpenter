extends Sprite
var velocity = 600
var direction = 1
const life = 300
var frameTimer = 0
func _physics_process(delta):
	position.x += velocity*direction*delta
	frameTimer += 1
	if frameTimer > life:
		queue_free()

func _on_Area2D_body_entered(body):
	if body.has_method("hurtWrench"):
		body.hurtWrench(velocity*direction/2)
		queue_free()
