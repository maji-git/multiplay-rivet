@icon("res://mp-addons/mpc-rivet/icons/RivetWSNetProtocol.svg")
extends WebSocketNetProtocol

class_name RivetWSNetProtocol

func _override_debug_url(bind_ip, port):
	return "default"

## Host function
func host(port, bind_ip, max_players) -> MultiplayerPeer:
	var peer = super(port, bind_ip, max_players)
	var response = await Rivet.matchmaker.lobbies.ready({})
	
	return peer

func join(address, _port) -> MultiplayerPeer:
	
	mpc.debug_status_txt = "Finding Rivet Lobby '{address}'...".format({address = address})
	
	var response = await Rivet.matchmaker.lobbies.find({
		"game_modes": [address]
	})
	
	if response.result != OK:
		assert(false, "Lobby find failed")
	
	RivetHelper.set_player_token(response.body.player.token)
	
	var port = response.body.ports.default
	
	var peer = super(port.hostname, port.port)
	
	return peer
