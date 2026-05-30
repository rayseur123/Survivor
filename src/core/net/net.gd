extends Control

@export var IP_ADDRESS = "127.0.0.1"
@export var PORT = 4242

var id = 0

func _ready() -> void:
	id = multiplayer.get_unique_id()
	multiplayer.peer_connected.connect(_on_peer_connected)

func createClient() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer


func createServer() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer	

func _on_peer_connected(id_client) -> void:
	if multiplayer.is_server():
		print("NEW CLIENT : ", id_client)


func _on_create_client_pressed() -> void:
	createClient()


func _on_create_server_pressed() -> void:
	createServer()
