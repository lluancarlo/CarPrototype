extends Node3D


@export var car_path : NodePath
@export var camera_path : NodePath
@onready var _camera := get_node(camera_path) as Camera


func _on_user_interface_play_game():
	_camera.can_rotate = true
