extends Sprite
var velocity = 6000
var direction = 1
const life = 300
var frameTimer = 0
func _physics_process(delta):
	position.x += velocity*direction*delta
	frameTimer += 1
	if frameTimer > life:
		queue_free()

func _on_Area2D_area_entered(area):
	if area.has_method("hurt"):
		area.hurt()
