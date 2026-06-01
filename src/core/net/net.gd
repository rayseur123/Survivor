extends Control

@export var IP_ADDRESS = "127.0.0.1"
@export var PORT = 4245
@export var map: PackedScene
@export var player: PackedScene

var current_map

var id = 0

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func createClient() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	id = multiplayer.get_unique_id()

func createServer() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer	
	id = multiplayer.get_unique_id()
	load_map()

func load_map() -> void:
	current_map = map.instantiate()
	current_map.name = "defaultMap"
	add_child(current_map)
	
	var server_player = player.instantiate()
	server_player.name = "1"
	server_player.set_multiplayer_authority(1)
	current_map.add_child(server_player)

func _on_player_connected(id_client) -> void:
	if (multiplayer.is_server()):
		var client_player = player.instantiate()
		client_player.name = str(id_client)
		client_player.set_multiplayer_authority(id_client)
		current_map.add_child(client_player)
		

func _on_connected_ok() -> void:
	print("Connection ok")
	
func _on_connected_fail() -> void:
	print("Connection fail")

func _on_server_disconnected() -> void:
	print("Server leave")

func _on_player_disconnected(id_client) -> void:
	if multiplayer.is_server():
		print("THE CLIENT : ", id_client, " LEAVES")

func _on_create_client_pressed() -> void:
	createClient()
	hide()

func _on_create_server_pressed() -> void:
	createServer()
	hide()
