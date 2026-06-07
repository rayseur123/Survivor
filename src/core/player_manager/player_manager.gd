extends Node

var players = {}

func add_player(player_node: Node3D) -> void:
	players[player_node.name] = player_node
	
func remove_player(player_node: Node3D) -> void:
	players.erase(player_node.name)
	
func get_nearest_player(from_position: Vector3) -> Node3D:
	var nearest = null
	var nearest_dist = INF
	for player in players.values():
		var dist = from_position.distance_to(player.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = players
	return nearest
