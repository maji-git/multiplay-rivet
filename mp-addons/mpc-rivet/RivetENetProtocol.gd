@icon("res://mp-addons/mpc-rivet/icons/RivetENetProtocol.svg")
extends ENetProtocol

class_name RivetENetProtocol

func _override_debug_url(bind_ip, port):
	return "default"

## Host function
func host(port, bind_ip, max_players) -> MultiplayerPeer:
	role = "server"
	var peer = ENetMultiplayerPeer.new()
	peer.set_bind_ip(bind_ip)
	var err = peer.create_server(port, max_players)
	
	_apply_peer_config(peer, bind_ip)
	
	if err != OK:
		MPIO.logerr("Server host failed")
	
	print("Rivet Running Matchmaker Ready...")
	var response = await Rivet.matchmaker.lobbies.ready({})

	if response.result == OK:
		print("Lobby ready")
	else:
		print("Lobby ready failed")
	
	return peer

func join(address, _port) -> MultiplayerPeer:
	role = "client"
	
	mpc.debug_status_txt = "Finding Rivet Lobby '{address}'...".format({address = address})
	
	var response = await Rivet.matchmaker.lobbies.find({
		"game_modes": [address]
	})
	
	if response.result != OK:
		assert(false, "Lobby find failed")
	
	RivetHelper.set_player_token(response.body.player.token)
	
	var port = response.body.ports.default
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(port.hostname, port.port)
	
	_apply_peer_config(peer, port.hostname)
	
	RivetHelper._assert(!error, "Could not start server")
	
	return peer
