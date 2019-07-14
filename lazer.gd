extends Sprite
var velocity = 6000
var direction = 1
func _physics_process(delta):
	position.x += velocity*direction*delta

func _on_Area2D_area_entered(area):
	if area.has_method("hurt"):
		area.hurt()
