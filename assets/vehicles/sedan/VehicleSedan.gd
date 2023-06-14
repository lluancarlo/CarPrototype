extends VehicleBody3D
class_name Car

const HEADLIGHT_ENERGY := [0.0, 2.0, 4.0]
#
@onready var _car_body := $Body as MeshInstance3D
@onready var _car_wbleft := $WBackLeft as VehicleWheel3D
@onready var _car_wbright := $WBackRight as VehicleWheel3D
#
@export var light_night_mode : bool
#
var engine_status := true
var headlights := 0
var max_rpm := 800
var max_torque := mass * 2.0


func _unhandled_key_input(_event : InputEvent) -> void:
	if Input.is_action_just_pressed("back"):
		_breaklights(true)
	elif Input.is_action_just_released("back"):
		_breaklights(false)
	elif Input.is_action_just_pressed("light"):
		_headlights(headlights+1 if headlights+1 < HEADLIGHT_ENERGY.size() else 0)


func _physics_process(d : float) -> void:
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5 * d)
	if engine_status:
		accelerate(Input.get_axis("back", "forward"))


func accelerate(speed : float) -> void:
	_car_wbleft.engine_force = speed * max_torque * ( 1 - _car_wbleft.get_rpm() / max_rpm)
	_car_wbright.engine_force = speed * max_torque * ( 1 - _car_wbright.get_rpm() / max_rpm)


func get_color() -> Color:
	return _car_body.mesh.surface_get_material(2).albedo_color


func set_color(color : Color) -> void:
	_car_body.mesh.surface_get_material(2).albedo_color = color


func _headlights(level : int) -> void:
	headlights = level
	var m := _car_body.mesh.surface_get_material(3)
	m.emission_energy_multiplier = HEADLIGHT_ENERGY[level]
	_car_body.mesh.surface_set_material(3, m)


func _breaklights(is_on : bool) -> void:
	var m := _car_body.mesh.surface_get_material(6)
	m.emission_energy_multiplier = 10.0 if is_on else (2.0 if light_night_mode else 0.0)
	_car_body.mesh.surface_set_material(6, m)
