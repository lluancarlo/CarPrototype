extends VehicleBody3D
class_name Car


@onready var _car_body := $Body as MeshInstance3D
@onready var _car_wbleft := $WBackLeft as VehicleWheel3D
@onready var _car_wbright := $WBackRight as VehicleWheel3D
@onready var _hlright := $HLRight as SpotLight3D
@onready var _hlleft := $HLLeft as SpotLight3D
#
@export var light_night_mode : bool
#
var engine_status := true
var headlights := 0
var max_rpm := 800
var max_torque := mass * 2.0


func _enter_tree():
	set_multiplayer_authority(name.replace("P_","").to_int())


func _ready() -> void:
	if not is_multiplayer_authority(): return


func _unhandled_key_input(_event : InputEvent) -> void:
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed("back"):
		_breaklights(true)
	elif Input.is_action_just_released("back"):
		_breaklights(false)
	elif Input.is_action_just_pressed("light"):
		_headlights(headlights+1 if headlights+1 < 3 else 0)
	elif Input.is_action_just_pressed("reset"):
		_reset()


func _physics_process(d : float) -> void:
	if not is_multiplayer_authority(): return
	
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


func _reset() -> void:
	print("RESET")
	global_transform.origin = Vector3(0.0, 1.0, 0.0)
	global_position.y += 1.0


func _headlights(level : int) -> void:
	headlights = level
	var m := _car_body.mesh.surface_get_material(3)
	match(level):
		1:
			m.emission_energy_multiplier = 2.0
			_hlright.light_energy = 10.0
			_hlright.spot_range = 5.0
			_hlleft.light_energy = 10.0
			_hlleft.spot_range = 5.0
		2:
			m.emission_energy_multiplier = 4.0
			_hlright.light_energy = 20.0
			_hlright.spot_range = 10.0
			_hlleft.light_energy = 20.0
			_hlleft.spot_range = 10.0
		_:
			m.emission_energy_multiplier = 0.0
			_hlright.light_energy = 0.0
			_hlright.spot_range = 0.0
			_hlleft.light_energy = 0.0
			_hlleft.spot_range = 0.0
	
	_car_body.mesh.surface_set_material(3, m)


func _breaklights(is_on : bool) -> void:
	var m := _car_body.mesh.surface_get_material(6)
	m.emission_energy_multiplier = 10.0 if is_on else (2.0 if light_night_mode else 0.0)
	_car_body.mesh.surface_set_material(6, m)
