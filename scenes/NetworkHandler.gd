extends Node
class_name NetworkHandler

@export var _player_scene : PackedScene
@onready var _network_spawn := $NetworkSpawner

var peers_connected := []


func _on_UserInterface_online_create_host(_host_name: String, host_ip: int):
	var peer := ENetMultiplayerPeer.new()
	var err = peer.create_server(host_ip)
	
	if err == OK:
		peer.peer_connected.connect(_on_peer_connected)
		peer.peer_disconnected.connect(_on_peer_disconnected)
		multiplayer.multiplayer_peer = peer
		
		create_player(multiplayer.get_unique_id())
		print("Server online!")
		
	else:
		printerr("Error on create server: ", err)


func _on_UserInterface_online_connect_server(server_address: String, server_ip: int):
	var peer := ENetMultiplayerPeer.new()
	var err = peer.create_client(server_address, server_ip)
	
	if err == OK:
		multiplayer.multiplayer_peer = peer
		print("Connected to the server!")
		
	else:
		printerr("Error on connect to server: ", err)


func _on_peer_connected(id: int):
	peers_connected.append(id)
	print("Peers connected: ", peers_connected)
	create_player(id)


func _on_peer_disconnected(id: int):
	peers_connected.pop_at(peers_connected.find(id))
	print("Peers connected: ", peers_connected)
	destroy_player(id)


func create_player(id: int):
	var p = _player_scene.instantiate()
	p.name = "p_" + str(id)
	_network_spawn.add_child(p)
#	p.rpc_id(id, "_set_global_position")


func destroy_player(id: int):
	var p = _network_spawn.get_node_or_null("p_" + str(id))
	if p != null:
		p.queue_free()
