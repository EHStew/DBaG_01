extends CharacterBody2D

var dir = Vector2.ZERO
var dashDir = Vector2.ZERO

var screenSize


const maxSpeed = 300
const accel = 10000
const friction = 8000
const dashMod = 20
var fric = friction
var stunFric = friction * 3

var stunned = false

var healthTotal = 100

var canMove = true
var walkSpeed = accel

var timeSlowed = false
var slowFactor = 1

var player_fol = Vector2(1,1)
var old_player_pos


var dashSpeed = accel * dashMod
var dashSpeedCap = maxSpeed * 6
var canDash = true
var dashing = false
var dashLength = .2

var blinkCount = 0
var tBubbleCount = 0

func _ready():
	screenSize = get_viewport_rect().size
	old_player_pos = global_position




func _physics_process(delta):
	player_movement(delta)
	
	player_fol = global_position - old_player_pos
	old_player_pos = global_position




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
	if not stunned:
		if not dashing:
			if dir == Vector2.ZERO:
				if velocity.length() > (fric * delta):
					velocity -= velocity.normalized() * (fric * delta)
				else:
					velocity = Vector2.ZERO
			else:
					velocity += (dir * walkSpeed * delta)
					velocity = velocity.limit_length(maxSpeed) 
		else:
			velocity += (dashDir * dashSpeed * delta)
			velocity = velocity.limit_length(dashSpeedCap) 
	else:
		stun(delta)

	move_and_slide()
	# Restrict player movement to view boundraries
	position.x = clamp(position.x, 0, screenSize.x)
	position.y = clamp(position.y, 0, screenSize.y)


func dash():

	if Input.is_action_just_pressed("dash"):
		if blinkCount >= 1:
			print("Dashing")
			dashing = true
			blinkCount -= 1
			await  get_tree().create_timer(.05).timeout
			self.hide()
			await  get_tree().create_timer(.08).timeout
			await  get_tree().create_timer(dashLength/3).timeout
			dashing = false
			await  get_tree().create_timer(.02).timeout
			self.show()



#func slow_time():
	if Input.is_action_just_pressed("use_power"):
		if tBubbleCount >= 1:
			var tBubble = load("res://time_bubble.tscn")
			var instance = tBubble.instantiate()
			$/root/Main.add_child(instance)
			tBubbleCount -=1
	else:
		pass

func stun(delta):
	if not stunned:
		pass


func game_over():
	get_tree().quit()
