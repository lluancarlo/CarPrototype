extends Node3D

@onready var _inner := $InnerGimbal as Node3D
@onready var _cam := $InnerGimbal/Cam as Camera3D
#
@export var look_at: Node
@export var mouse_sens := 0.25
@export var zoom_sens := 0.25
#
var can_rotate : bool : set = _set_can_rotate
var vertical_limit := Vector2(0.0, -60.0)


func _set_can_rotate(new_value):
	can_rotate = new_value
	if new_value:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _process(_d) -> void:
	position = look_at.position


## Input Handler
func _unhandled_key_input(event):
	# Handle keys
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE:
			can_rotate = false


func _unhandled_input(event : InputEvent):
	# Mouse motion to move the camera 
	if can_rotate and event is InputEventMouseMotion:
		var mouse_motion = event.relative * mouse_sens
		
		# Horizontal move
		rotate_y(deg_to_rad(mouse_motion.x))
		
		# Vertical move
		var vertical_val := deg_to_rad(mouse_motion.y)
		if (vertical_val > 0.0 and _inner.rotation_degrees.x < vertical_limit.x) or (vertical_val < 0.0 and _inner.rotation_degrees.x > vertical_limit.y):
			_inner.rotate_x(vertical_val)
	
	elif event is InputEventMouseButton:
		# Click on screen to capture the mouse
		if event.button_index == 1 and event.is_pressed():
			can_rotate = true
		# Zoom out
		elif event.button_index == 4 and _cam.position.z < 20.0:
			_cam.position.z += zoom_sens
		# Zoom in
		elif event.button_index == 5 and _cam.position.z > 2.0:
			_cam.position.z -= zoom_sens
##
