extends KinematicBody2D

var velocity = Vector2(0,0)
export var acceleration = 50
export var jumpSpeed = 800
export var gravity = 35
export var maxAirVelocity = Vector2(450,1500)
export var maxVelocity = Vector2(400, 1500)
export var totalJumps = 2

const iframes = 60
var iTimer = 0
var invuln = false

var healing = false
var hTimer = 0

var fixing = false

var grounded = true
var midairJumpsLeft = totalJumps - 1
var anim

signal animate

#---------------------------------------------
func _ready():
	gravity = Global.gravity
	anim = $AnimatedSprite

func _physics_process(delta):
	imposeGravity()
	calculateJump()
	checkInvuln()
	healing()
	if not fixing:
		movement()
	animate()
#---------------------------------------------

func checkInvuln():
	if invuln:
		iTimer += 1
		if iTimer > iframes:
			invuln = false
			iTimer = 0

func imposeGravity():
	velocity.y += gravity

func calculateJump():
	if is_on_floor():
		grounded = true
		midairJumpsLeft = totalJumps-1
	elif is_on_ceiling():
		velocity.y = 1
	else: 
		grounded = false

func parseInputs(lerpWeight):
	if Input.is_action_just_pressed("player_jump"):
		if midairJumpsLeft > 0 && not grounded:
			midairJumpsLeft -= 1
			velocity.y = -jumpSpeed
		elif grounded:
			velocity.y = -jumpSpeed

	var left = Input.is_action_pressed("player_left");
	var right = Input.is_action_pressed("player_right");
	
	var maxSpeeds
	if grounded: maxSpeeds = maxVelocity
	else: maxSpeeds = maxAirVelocity
	
	if right && not left:
		velocity.x += acceleration
		velocity.x = min(velocity.x, maxSpeeds.x)
	elif left && not right:
		velocity.x -= acceleration
		velocity.x = max(velocity.x, -maxSpeeds.x)
	else:
		velocity.x = lerp(velocity.x, 0, lerpWeight)
	velocity.y = min(velocity.y, maxSpeeds.y)

func healing():
	if healing:
		hTimer += 1
		if hTimer > 30:
			Global.playerHP += 1 
			hTimer = 1
	else:
		hTimer = 0 

func movement():
	parseInputs(0.5)
	velocity = move_and_slide(velocity, Global.UP)
	if abs(velocity.x) <= 1:
		velocity.x = 0
	if abs(velocity.y) <= 1:
		velocity.y = 0

func hurtEnemy(enemy):
	if not invuln:
		velocity.x += enemy.x * 2.5
		velocity.y = enemy.y-jumpSpeed/2
		getHurt(20)
		return true
	else: return false

func getHurt(dmg):
	fixing = false
	midairJumpsLeft = 0
	Global.playerHurt(dmg)
	invuln = true

func startHealing():
	healing = true
func stopHealing():
	healing = false
	
func animate():
	if velocity.x > 0:
		anim.play("walk")
		anim.flip_h = false
	elif velocity.x < 0:
		anim.play("walk")
		anim.flip_h = true
	else:
		anim.play("idle")
	
		

