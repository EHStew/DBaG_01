extends Node2D

var dir = 0
var bullet_speed = 10

func _ready():
	pass


func _process(delta):
	var move_dir = Vector2(1,0).rotated(dir)
	global_position += (move_dir * bullet_speed)



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
