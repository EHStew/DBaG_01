extends Area2D

@export var move_speed : float = 300
@export var move_dir : Vector2

var start_pos : Vector2
var target_pos : Vector2

@onready var target = $"/root/Main/Player"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		target_pos = target.global_position
		if global_position != target_pos:
			global_position = global_position.move_toward(target_pos, move_speed * (delta * target.slowFactor))




func _on_body_entered(body):
	if target.dashing == false:
		if body.is_in_group("Player"):
			body.game_over()
