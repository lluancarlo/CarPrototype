class_name ChangeColor extends Node3D


@onready var _label := $Label3D as Label3D
signal change_car_color(current_color : Color)


func _on_area_3d_body_shape_entered(_body_rid : RID, body : Node3D, _body_shape_index : int, _local_shape_index : int):
	if body is VehicleBody3D:
		_label.look_at(body.position)
		body.brake = 30.0
		body.engine_status = false
		change_car_color.emit(body.get_color())
