extends Node3D


@export var gui_path : NodePath
@export var car_path : NodePath
@onready var _gui := get_node(gui_path) as GUI
@onready var _car := get_node(car_path) as Car


func _on_change_car_color(current_color : Color) -> void:
	_gui.show_change_color(current_color)


func _on_gui_color_changing(color : Color) -> void:
	_car.set_color(color)


func _on_gui_color_close():
	_car.brake = 0
	_car.engine_status = true
