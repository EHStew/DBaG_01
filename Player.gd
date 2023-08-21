extends Area2D
@export var speed = 400
var screen_size
var blink_counter = 0
var canMove = true
var canDash = true
var dashSpeed = 50
var dashFrames = 0



func _process(delta): # Player Movement
	# Start player with 0 velocity, 0.0 vector
	var velocity = Vector2.ZERO
	if canMove:
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		# Reign in velocity so you dont move 2Xspeed diagonally
		if velocity.length() > 0:
			velocity = velocity.normalized() * speed
			
	if Input.is_action_pressed("dash"):
		if canDash:
			
			canDash = false
			canMove = false
			if velocity.x > 0:
					velocity.x = velocity.x*dashSpeed
			elif velocity.x < 0:
					velocity.x = velocity.x*dashSpeed
			if velocity.y > 0:
					velocity.y = velocity.y*dashSpeed
			elif velocity.x < 0:
					velocity.y = velocity.y*dashSpeed
		
	## Using delta ensures that our movement speed in-game will not be impacted by framerate
	position += velocity * delta
	
