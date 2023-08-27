extends Node2D

var rotation_angle = 50
var angle_from = 0
var angle_to = 0
var t_Angle_from = 0
var t_Angle_to = 0
var timerWidth = 7
var bubbleBuildSpeed = 15
var bubbleBuilt = false
var bubbleTime = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = $/root/main/player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotate arc 
	# angle_from += rotation_angle * delta
	# angle_to += rotation_angle * delta

	# We only wrap angles when both of them are bigger than 360.
	if angle_from > 360 and angle_to > 360:
		angle_from = wrapf(angle_from, 0, 360)
		angle_to = wrapf(angle_to, 0, 360)
	
	if not bubbleBuilt:
		build_bubble()
	elif bubbleBuilt:
		bubble_Timer(delta)
	
	queue_redraw()

func build_bubble():
	if angle_to < 360:
		angle_to += bubbleBuildSpeed
		t_Angle_from = angle_from
		t_Angle_to = angle_to
	elif  angle_to + bubbleBuildSpeed >= 360:
		if angle_to < 360:
			angle_to += 1
			t_Angle_to = angle_to
		else:
			await  get_tree().create_timer(.5).timeout
			bubbleBuilt = true

		
func bubble_Timer(delta):
		if t_Angle_from < 360:
			t_Angle_from += bubbleTime * delta
		elif t_Angle_from >= 360:
			queue_free()
		
	
func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, timerWidth, true)
	
	
	
func draw_timer_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color, timerWidth * .80, true)


func _draw():
	var center = Vector2.ZERO
	var radius = 150
	var color = Color(1.0, 1.0, 1.0)

	draw_circle_arc( center, radius, angle_from, angle_to, color )
	draw_timer_arc(center, radius, t_Angle_from, t_Angle_to, Color(0.0, 0.0, 0.0))
