extends Area2D

var dir = 0
var bullet_speed = 10
var slowFactor = 1

signal hit

func _ready():
	pass


func _process(delta):
	var move_dir = Vector2(1,0).rotated(dir)
	global_position += (move_dir * bullet_speed * slowFactor)



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.healthTotal -= 10
		body.stunned = true
