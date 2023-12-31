extends Area2D

var rotation_angle = 50
var angle_from = 0
var angle_to = 0
var t_Angle_from = 0
var t_Angle_to = 0
var timerWidth = 7
var bubbleBuildSpeed = 15
var bubbleBuilt = false
var bubbleTime = 100
var radius = 150
var bubbleExists = false
var slowAmount = .3


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = $/root/Main/Player
	global_position = player.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_overlap()
	create_bubble(delta)
	queue_redraw()




func build_bubble():
	if angle_to < 360:
		angle_to += bubbleBuildSpeed
		t_Angle_from = angle_from
		t_Angle_to = angle_to
	elif  angle_to + bubbleBuildSpeed >= 360:
		if angle_to < 360:
			angle_to += 1
			t_Angle_to = angle_to -10
		else:
			await  get_tree().create_timer(.2).timeout
			bubbleBuilt = true

func bubble_Timer(delta, area):
		if t_Angle_from < 360:
			t_Angle_from += bubbleTime * delta
		elif t_Angle_from >= 360:
			t_Angle_from = 360
			if angle_from <= angle_to:
				if  angle_from + bubbleBuildSpeed < angle_to:
					angle_from += bubbleBuildSpeed
				else:
					angle_from += 5
			else:
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

func handle_overlap():
	if angle_from > 360 and angle_to > 360:
		angle_from = wrapf(angle_from, 0, 360)
		angle_to = wrapf(angle_to, 0, 360)



func create_bubble(delta):
	var area
	var shape
	var collision
	var center
	var bubblePos
	if not bubbleExists:
		area = Area2D.new()
		shape = CircleShape2D.new()
		shape.set_radius(radius)
		collision = CollisionShape2D.new()
		collision.set_shape(shape)
		center = Vector2.ZERO
		bubblePos = Vector2.ZERO
		add_child(collision) 
		set_monitoring(true)
		bubbleExists = true
	else:
		pass
	
	if not bubbleBuilt:
		build_bubble()
	elif bubbleBuilt:
		bubble_Timer(delta, area)
	
	# Put overlapping areas in array
	#var area_list = area.get_overlapping_areas()
	#print(area_list)
	#for i in area_list:
	#	if i.has_method("get_slowed"): 
	#		i.get_slowed()



func _draw():
	var center = Vector2.ZERO
	var color = Color(1.0, 1.0, 1.0)

	draw_circle_arc( center, radius, angle_from, angle_to, color )
	draw_timer_arc(center, radius, t_Angle_from, t_Angle_to, Color(0.0, 0.0, 0.0))



func _on_area_entered(area):
	if area.is_in_group("Slowable"):
		area.slowFactor = slowAmount
func _on_area_exited(area):
	if area.is_in_group("Slowable"):
		area.slowFactor = 1
