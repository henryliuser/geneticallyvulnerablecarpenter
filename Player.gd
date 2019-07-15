extends KinematicBody2D

var velocity = Vector2(0,0)
export var acceleration = 70
export var jumpSpeed = 800
export var gravity = 35
export var maxAirVelocity = Vector2(450,1500)
export var maxVelocity = Vector2(400, 1500)
export var totalJumps = 2

const iframes = 60
var iTimer = 0
var invuln = false

const hitStunTime = 25
var inHitStun = false
var hitStunTimer = 0

var healing = false
var hTimer = 0

var fixing = false

var attacking = false
var attackTimer = 0

var grounded = true
var midairJumpsLeft = totalJumps - 1
var anim

signal animate
var attackHitbox
var attackOrigin
const originDist = 30
#---------------------------------------------
func _ready():
	gravity = Global.gravity
	anim = $AnimatedSprite
	attackOrigin = $hurtBox/attackOrigin
	attackHitbox = load("res://Scenes/playerAttackHitBox.tscn")
	
func _physics_process(delta):
	if position.y > 1200:
		Global.playerHP = 0
	imposeGravity()
	calculateJump()
	checkInvuln()
	healing()
	if inHitStun:
		calculateHitStun()
	if attacking: 
		calculateAttack()
	if not fixing and not inHitStun:
		movement()
	velocity = move_and_slide(velocity*Global.speedMultiplier, Global.UP)
	if not attacking:
		animate()
#---------------------------------------------
func calculateHitStun():
	hitStunTimer += 1
	if hitStunTimer > hitStunTime:
		hitStunTimer = 0
		inHitStun = false
		modulate = Color(1,1,1,1)

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
#	if is_on_ceiling():
#		velocity.y = 10
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
	var attack = Input.is_action_just_pressed("player_attack")
	var crouch = Input.is_action_just_pressed("player_crouch")
	
	if attack and not attacking:
		startAttack()
	
	if crouch:
		anim.play("crouch")
		$hurtBox
	
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
	if abs(velocity.x) <= 1:
		velocity.x = 0
	if abs(velocity.y) <= 1:
		velocity.y = 0

func hurtEnemy(enemy):
	if not invuln:
		velocity.x += enemy.x * 1.2
		velocity.y = enemy.y-jumpSpeed/2
		getHurt(20)
		return true
	else: return false

func getHurt(dmg):
	inHitStun = true
	hitStunTimer += 1
	modulate = Global.hurtColor
	fixing = false
	midairJumpsLeft = 0
	Global.playerHurt(dmg)
	if Global.playerHP <= 0:
		queue_free()
	invuln = true

func startHealing():
	healing = true
func stopHealing():
	healing = false
	
func animate():
	if velocity.y < 0:
		anim.play("jump")
	elif velocity.y > 0:
		anim.play("fall")
	elif velocity.x != 0:
		anim.play("walk")
	elif Input.is_action_pressed("player_crouch"):
		anim.play("crouch")
	else:
		anim.play("idle")

	if velocity.x > 0:
		anim.flip_h = false
		attackOrigin.position.x = originDist
	elif velocity.x < 0:
		anim.flip_h = true
		attackOrigin.position.x = -originDist
	
func startAttack():
	anim.play("attack22")
	attacking = true
	attackTimer += 1

func calculateAttack():
	attackTimer += 1
	if attackTimer == 5:
		var hitbox = attackHitbox.instance()
		hitbox.velocity = attackOrigin.position.x/30*400
		attackOrigin.add_child(hitbox)
	if attackTimer > 20:
		attacking = false
		attackTimer = 0
