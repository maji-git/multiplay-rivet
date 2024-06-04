extends MPExtension

func _ready():
	super()
	RivetHelper.start_server.connect(start_server)
	RivetHelper.setup_multiplayer()

func start_server():
	await get_tree().create_timer(0.5).timeout
	print("[MPC-Rivet] Starting Online Host")
	mpc.start_online_host()
	print("[MPC-Rivet] Called MPC")
