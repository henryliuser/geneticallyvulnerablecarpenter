extends KinematicBody2D
export var speed = 400
export var xDirec = 1.0
export var patrolX = false
export var xCoord = Vector2(0,0)
export var patrolY = false
export var yCoord = Vector2(0,0)
export var health = 3
onready var anim = $AnimatedSprite
var orb = false
var velocity = Vector2(400,0)
var gravity = 35

var hurt = false
var hurtTimer = 0
const hitStun = 30

func _ready():
	gravity = Global.gravity

func _physics_process(delta):
	imposeGravity()
	if hurt:
		calculateHurt()
	else:
		calculateDirection()
	velocity = move_and_slide(velocity, Global.UP)
	if is_on_wall():
		xDirec *= -1
	if position.y > 1100:
		die()

func calculateDirection():
	if not orb:
		if xDirec > 0:
			anim.flip_h = false
		else: anim.flip_h = true
	if velocity.x <= 1:
		velocity.x = speed*xDirec
	else:
		velocity.x *= xDirec
	

func imposeGravity():
	velocity.y += gravity

func patrolX(x1,x2):
	if position.x > x2 or position.x < x1:
		xDirec *= -1

func patrolY(y1,y2):
	if position.y > y2 or position.x < y1:
		velocity.y *= -1

func _on_Area2D_body_entered(body):
	if body.has_method("hurtEnemy"):
		if body.hurtEnemy(velocity):
			xDirec *= -1

func hurtWrench(vel):
	modulate = Global.hurtColor
	hurt = true;
	hurtTimer += 1
	velocity.x = vel
	velocity.y = -400
	health -= 1
	if health <= 0:
		die()

func calculateHurt():
	hurtTimer += 1
	if hurtTimer > hitStun:
		modulate = Color(1,1,1,1)
		hurt = false
		hurtTimer = 0

func _on_Area2D_area_entered(area): #other enemy
	if area.has_method("hurtWrench"): 
		xDirec *= -1

func die():
	#maybe add animación
	queue_free()
