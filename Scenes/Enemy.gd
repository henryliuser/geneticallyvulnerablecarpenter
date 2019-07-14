extends KinematicBody2D
export var speed = 400
export var xDirec = 1.0
export var patrolX = false
export var xCoord = Vector2(0,0)
export var patrolY = false
export var yCoord = Vector2(0,0)

var velocity = Vector2(400,0)
var gravity = 35

func _ready():
	gravity = Global.gravity

func _physics_process(delta):
	imposeGravity()
#	if Global.debug:
#		Global.dPrint(self,str(velocity))
	if velocity.x <= 1:
		velocity.x = speed*xDirec
	velocity = move_and_slide(velocity, Global.UP)
	if is_on_wall():
		xDirec *= -1

func imposeGravity():
	velocity.y += gravity

func patrolX(x1,x2):
	if position.x > x2 or position.x < x1:
		velocity.x *= -1

func patrolY(y1,y2):
	if position.y > y2 or position.x < y1:
		velocity.y *= -1

func _on_Area2D_body_entered(body):
	if body.has_method("hurtEnemy"):
		if body.hurtEnemy(velocity):
			hurt()

func hurt():
	xDirec *= -1
	velocity.x *= -1 

func _on_Area2D_area_entered(area): #other enemy
	xDirec *= -1
	velocity.x *= -1
