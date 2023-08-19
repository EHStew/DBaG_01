extends Area2D
@export var speed = 400
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta): # Player Movement
	# Start player with 0 velocity, 0.0 vector
	var velocity = Vector2.ZERO
	
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
	
	## Using delta ensures that our movement speed in-game will not be impacted by framerate
	position += velocity * delta
	
	# Restrict player movement to view boundraries
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)

