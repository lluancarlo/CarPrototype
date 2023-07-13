extends Control


signal back_to_main_menu()
signal create_host(host_name: String, host_ip: int)
signal connect_server(server_address: String, server_ip: int)

@onready var _client_ip := $TabContainer/Client/VBox/HBox/Fields/Ip as TextEdit
@onready var _client_port := $TabContainer/Client/VBox/HBox/Fields/Port as TextEdit
@onready var _host_name := $TabContainer/Host/VBox/HBox/Fields/ServerName as TextEdit
@onready var _host_port := $TabContainer/Host/VBox/HBox/Fields/Port as TextEdit



func _on_back_pressed():
	back_to_main_menu.emit()


func _on_connect_pressed():
	connect_server.emit(_client_ip.text, int(_client_port.text))


func _on_create_server_pressed():
	create_host.emit(_host_name.text, int(_host_port.text))
