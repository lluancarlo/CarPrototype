extends Node3D
class_name Player


@onready var hud_name := $HUD/PlayerName as Label3D
@onready var car := $PlayerCar as PlayerCar
@onready var cam := $PlayerCamera as PlayerCamera


var netword_id : int :
	set(value):
		netword_id = value
		name = str(value)
		set_multiplayer_authority(value)


var nickname : String :
	set(value):
		nickname = value
		hud_name.text = value

