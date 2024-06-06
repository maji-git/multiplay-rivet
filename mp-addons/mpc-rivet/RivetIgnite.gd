@icon("res://mp-addons/mpc-rivet/icons/RivetIgnite.svg")
extends MPExtension

## Rivet Server Starter
class_name RivetIgnite

## Start automatically as client
@export var auto_start_client: bool = false

## Gamemode Lobby name to join, only works with auto_start_client enabled.
@export var client_join_gamemode: String = "default"

func _mpc_ready():
	super()
	RivetHelper.start_server.connect(start_server)
	RivetHelper.start_client.connect(start_client)
	RivetHelper.setup_multiplayer()

func start_server():
	mpc.start_online_host()

func start_client():
	if auto_start_client:
		mpc.start_online_join(client_join_gamemode)
