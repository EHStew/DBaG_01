extends CharacterBody2D

var dir = Vector2.ZERO
var dashDir = Vector2.ZERO

var screenSize


const maxSpeed = 800
const accel = 10000
const friction = 8000
const dashMod = 10

var canMove = true
var walkSpeed = accel

var timeSlowed = false
var slowFactor = 1


var dashSpeed = accel * dashMod
var dashSpeedCap = maxSpeed * 6
var canDash = true
var dashing = false
var dashFriction = friction 
var dashLength = .2

var blinkCount = 0
var tBubbleCount = 0

func _ready():
	screenSize = get_viewport_rect().size




func _physics_process(delta):
	player_movement(delta)




func get_dir():
	if not dashing:
		dir.x = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed(("move_left")))
		# 1 = right | -1 = left
		dir.y = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed(("move_up")))
		if dir != Vector2.ZERO:
			dashDir.x = dir.x
			dashDir.y = dir.y
		return dir.normalized()
	elif dashing:
		return dashDir.normalized()




func player_movement(delta):
	dir = get_dir()
	dash()
	
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
		velocity += (dashDir * dashSpeed * delta)
		velocity = velocity.limit_length(dashSpeedCap) 


	move_and_slide()
	# Restrict player movement to view boundraries
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)

#func time_bubble():
	

func dash():
	if Input.is_action_just_pressed("dash"):
		if blinkCount >= 1:
			print("Dashing")
			dashing = true
			blinkCount -= 1
			await  get_tree().create_timer(.05).timeout
			self.hide()
			await  get_tree().create_timer(.08).timeout
			dashSpeedCap = 1000
			await  get_tree().create_timer(dashLength/3).timeout
			dashing = false
			await  get_tree().create_timer(.02).timeout
			self.show()
			dashSpeedCap = maxSpeed * 6



#func slow_time():
	if Input.is_action_just_pressed("use_power"):
		if tBubbleCount >= 1:
			var tBubble = load("res://time_bubble.tscn")
			var instance = tBubble.instantiate()
			$/root/Main.add_child(instance)
			tBubbleCount -=1
	else:
		pass


func game_over():
	get_tree().quit()
