extends Node

# Form: { 1: 1234 } - (player_id: peer_id)
@rpc("authority", "call_remote", "reliable", 0)
func receive_player_ids(table: Dictionary):
	for player_id in table:
		var peer_id = table[player_id]
		var found_player = get_node("/root").find_child("Player " + str(player_id), true, false)
		found_player.set_multiplayer_authority(peer_id)
