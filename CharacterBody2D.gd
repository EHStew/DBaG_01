extends CharacterBody2D

var screenSize


const maxSpeed = 800
const accel = 10000
const friction = 8000

var canMove = true
var walkSpeed = accel
var dashSpeed = accel * 10
var canDash = true
var dashing = false
var dashFriction


var dir = Vector2.ZERO

func _ready():
	screenSize = get_viewport_rect().size




func _physics_process(delta):
	player_movement(delta)




func get_dir():
	dir.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed(("move_left")))
	# 1 = right | -1 = left
	dir.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed(("move_up")))
	return dir.normalized()




func player_movement(delta):
	dir = get_dir()
	if not dashing:
		if dir == Vector2.ZERO:
			if velocity.length() > (friction * delta):
				velocity -= velocity.normalized() * (friction * delta)
			else:
				velocity = Vector2.ZERO
		else:
			velocity += (dir * walkSpeed * delta) 
			velocity = velocity.limit_length(maxSpeed)
	else:
		velocity += (dir * dashSpeed * delta) 
		
	move_and_slide()
	# Restrict player movement to view boundraries
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)

func dash():
	if Input.is_action_pressed("dash"):
		print("Dashing")
		dashing = true
		walkSpeed = dashSpeed
		await  get_tree().create_timer(1.0).timeout
		walkSpeed = accel
		dashing = false



func game_over():
	get_tree().quit()
