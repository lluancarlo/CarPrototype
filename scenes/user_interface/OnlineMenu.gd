extends Control


signal back_to_main_menu()
signal connect_server(player_name: String, server_address: String, server_ip: int)
signal create_host(player_name: String, host_ip: int)

const MIN_NAME_LENGTH := 3

@onready var _client_ip := $TabContainer/Client/VBox/HBox/Fields/Ip as TextEdit
@onready var _client_port := $TabContainer/Client/VBox/HBox/Fields/Port as TextEdit
@onready var _client_name := $TabContainer/Client/VBox/HBox/Fields/PlayerName as TextEdit
@onready var _client_connect := $TabContainer/Client/VBox/Buttons/Connect as Button

@onready var _host_name := $TabContainer/Host/VBox/HBox/Fields/PlayerName as TextEdit
@onready var _host_port := $TabContainer/Host/VBox/HBox/Fields/Port as TextEdit
@onready var _host_create := $TabContainer/Host/VBox/Buttons/CreateServer as Button


func _ready():
	_client_connect.disabled = true
	_host_create.disabled = true


func _on_back_pressed():
	back_to_main_menu.emit()


func _on_connect_pressed():
	connect_server.emit(_client_name.text, _client_ip.text, int(_client_port.text))


func _on_create_server_pressed():
	create_host.emit(_host_name.text, int(_host_port.text))


func _on_CLIENT_player_name_changed():
	_client_connect.disabled = _client_name.text.length() < MIN_NAME_LENGTH


func _on_HOST_player_name_changed():
	_host_create.disabled = _host_name.text.length() < MIN_NAME_LENGTH
