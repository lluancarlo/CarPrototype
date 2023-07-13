extends Control

@export var player : PackedScene
@export var network_path : NodePath

@onready var network := get_node(network_path) as MultiplayerSpawner

var m := ENetMultiplayerPeer.new()
var player_list := []
var port := 4242


func _ready():
	pass


func create_player(id):
	player_list.append(id)
	print("connected! ", id)
	
	var p = player.instantiate()
	p.name = str(id)
	network.add_child(p)


func destroy_player(id):
	player_list.pop_at(player_list.find(id))
	print("desconnected! ", id)
	
	network.get_node(str(id)).queue_free()


func _on_server_pressed():
	m.create_server(port)
	m.peer_connected.connect(create_player)
	m.peer_disconnected.connect(destroy_player)
	print("server running on localhost port ", port)
	get_tree().set_network_peer(m)


func _on_connect_pressed():
	m.create_client("localhost", 123)
	print("connecting to the server in port ", port)
	$Server.visible = false
	$Connect.visible = false


@rpc()
func _receive_msg(msg):
	print("received ", msg)
	$RichTextLabel.text += "\n" + msg


func _on_button_pressed():
	print("sending ", $TextEdit.text)
	rpc("_receive_msg", $TextEdit.text)
