extends Control


signal play_game()
signal online_create_host(player_name: String, host_ip: int)
signal online_connect_server(player_name: String, server_address: String, server_ip: int)

const FADE_TIME := 0.25

@onready var _main_menu := $MainMenu as Control
@onready var _online_menu := $OnlineMenu as Control
@onready var _ingame_menu := $InGameGUI as Control


## MAIN MENU
func _on_play_offline_pressed():
	_make_transition(_main_menu, _ingame_menu)
	get_tree().create_timer(FADE_TIME).timeout.connect(func(): play_game.emit())


func _on_play_online_pressed():
	_make_transition(_main_menu, _online_menu)
##


## ONLINE MENU
func _on_OnlineMenu_back_to_main_menu():
	_make_transition(_online_menu, _main_menu)


func _on_online_menu_connect_server(player_name: String, server_address: String, server_ip: int):
	online_connect_server.emit(player_name, server_address, server_ip)
	_make_transition(_online_menu, _ingame_menu)
	get_tree().create_timer(FADE_TIME).timeout.connect(func(): play_game.emit())


func _on_online_menu_create_host(player_name: String, host_ip: int):
	online_create_host.emit(player_name, host_ip)
	_make_transition(_online_menu, _ingame_menu)
	get_tree().create_timer(FADE_TIME).timeout.connect(func(): play_game.emit())
##


func _make_transition(from: Control, to: Control) -> void:
	var t := create_tween().set_parallel(true)
	t.tween_property(from, "modulate:a", 0.0, FADE_TIME)\
		.from(1.0).finished.connect(func(): from.visible = false)
	t.tween_property(to, "modulate:a", 1.0, FADE_TIME).from(0.0)
	to.visible = true
