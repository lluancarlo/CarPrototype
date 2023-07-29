extends Node
class_name NetworkHandler

@export var _player_scene := preload("res://scenes/player/player.tscn")
@onready var _network_spawn := $NetworkSpawner

var my_id : int
var my_name : String
var peers_connected := {}

func _on_UserInterface_online_create_host(host_name: String, host_ip: int):
	var peer := ENetMultiplayerPeer.new()
	var err = peer.create_server(host_ip)
	
	if err == OK:
		peer.peer_connected.connect(
			func(id: int):
				print(1)
				await get_tree().create_timer(0.1).timeout
				print(2)
				# Call for all peers and locally
				rpc("setup_new_player", id)
				print(3)
		)
		peer.peer_disconnected.connect(
			func(id: int):
				# Call for all peers and locally
				destroy_player(id)
		)
		
		multiplayer.multiplayer_peer = peer
		my_id = multiplayer.get_unique_id()
		my_name = host_name
		
		setup_new_player(my_id)
		
		print("Server online!")
		
	else:
		printerr("Error on create server: ", err)


func _on_UserInterface_online_connect_server(player_name: String, server_address: String, server_ip: int):
	var peer := ENetMultiplayerPeer.new()
	var err = peer.create_client(server_address, server_ip)
	
	if err == OK:
		multiplayer.multiplayer_peer = peer
		my_id = multiplayer.get_unique_id()
		my_name = player_name
		
		print("Connected to the server!")
		
	else:
		printerr("Error on connect to server: ", err)


@rpc("call_local")
func setup_new_player(id: int) -> void:
	var p = _player_scene.instantiate() as Player
	p.netword_id = id
	_network_spawn.add_child(p)
	p.nickname = my_name
	peers_connected[id] = p


@rpc("call_local")
func destroy_player(id: int):
	var p = _network_spawn.get_node_or_null("p_" + str(id))
	if p != null:
		p.queue_free()
		peers_connected.erase(id)
