extends Node2D
@onready var player = $/root/Main/Player


func _ready():
	pass # Replace with function body.


func _process(delta):
	time_bubble_ui()
	blink_dash_ui()


func time_bubble_ui():
	var bubbleNumber = player.tBubbleCount
	if bubbleNumber > 0:
		$timeBubbleUI.set_region_rect( Rect2( 0, 0,bubbleNumber * 40, 32))
	elif bubbleNumber <= 0:
		$timeBubbleUI.set_region_rect( Rect2( 0, 0, 0, 0 ))
		
func blink_dash_ui():
	var dashNumber = player.blinkCount
	if dashNumber > 0:
		$blinkDashUI.set_region_rect( Rect2( 0, 0,dashNumber * 40, 32))
	elif dashNumber <= 0:
		$blinkDashUI.set_region_rect( Rect2( 0, 0, 0, 0 ))
