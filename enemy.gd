extends Area2D

@export var move_speed : float = 300
@export var move_dir : Vector2

var start_pos : Vector2
var target_pos : Vector2

var slowFactor = 1
var hasShot = false

@onready var target = $"/root/Main/Player"
var bullet = PackedScene



# Called when the node enters the scene tree for the first time.s
func _ready():
	randomize()
	bullet = ResourceLoader.load("res://bullet.tscn")
	# Create a timer node
	var timer = Timer.new()
	# Set timer interval
	timer.set_wait_time(randf_range(1,3))
	# Set it as repeat
	timer.set_one_shot(false)
	# Connect its timeout signal to the function you want to repeat
	timer.timeout.connect(shoot_player)
	# Add to the tree as child of the current node
	add_child(timer)
	timer.start()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		target_pos = target.global_position
		predict_player_pos()
		if global_position != target_pos:
			global_position = global_position.move_toward(target_pos, move_speed * (delta * slowFactor))

func _on_body_entered(body):
	if target.dashing == false:
		if body.is_in_group("Player"):
			body.game_over()

func predict_player_pos():
	var dist = global_position.distance_to(target.global_position)
	look_at(target.global_position + target.player_fol * (dist/10))

func shoot_player():
	var bull = bullet.instantiate()
	bull.dir = rotation
	bull.rotation = rotation
	bull.global_position = global_position
	get_parent().add_child(bull)
	hasShot = false
