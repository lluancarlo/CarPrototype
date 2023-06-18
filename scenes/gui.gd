class_name GUI extends Control

signal color_changing(color : Color)
signal color_close()

@onready var _fps := $FPS/Value as Label
@onready var _change_color := $ChangeColor as Control


func _process(_delta):
	_fps.text = str(Engine.get_frames_per_second())


func show_change_color(color : Color = Color.WHITE) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_change_color.visible = true
	_change_color.get_node("VBox/ColorPicker").color = color


func _on_color_picker_color_changed(color : Color) -> void:
	color_changing.emit(color)


func _on_button_pressed():
	_change_color.visible = false
	color_close.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
