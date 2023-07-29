extends Control


@onready var _fps := $FPS/Value


func _on_timer_timeout():
	_fps.text = str(Engine.get_frames_per_second())
