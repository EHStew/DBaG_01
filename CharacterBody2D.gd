extends CharacterBody2D

var screenSize


const maxSpeed = 800
const accel = 10000
const friction = 8000



var input = Vector2.ZERO

func _ready():
	screenSize = get_viewport_rect().size




func _physics_process(delta):
	player_movement(delta)




func get_input():
	input.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed(("move_left")))
	# 1 = right | -1 = left
	input.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed(("move_up")))
	return input.normalized()




func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		if velocity.length() > (friction * delta):
			velocity -= velocity.normalized() * (friction * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (input * accel * delta) 
		velocity = velocity.limit_length(maxSpeed)
		
	
		
		
	move_and_slide()
	# Restrict player movement to view boundraries
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)




func game_over():
	get_tree().quit()
