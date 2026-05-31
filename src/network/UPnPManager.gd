extends Node

var _upnp: UPNP;
var _thread: Thread;
@onready var _timer: Timer = $PortTimer
var status := UpnpStatus.WAITING
var external_address: String;
var rng := RandomNumberGenerator.new();
var port: int = rng.randi_range(1024, 65535);

enum UpnpStatus {
	READY,
	WAITING,
	UNAVAILABLE
}

func _port_mapping() -> UPNP.UPNPResult:
	var res: UPNP.UPNPResult
	res = _upnp.add_port_mapping(port, 0, "The best survivor game", "UDP") as UPNP.UPNPResult
	
	call_deferred("_port_mapping_done")
	return res

func _port_mapping_done() -> void:
	var res: UPNP.UPNPResult = _thread.wait_to_finish()
	
	if res != UPNP.UPNP_RESULT_SUCCESS or !(_upnp.get_gateway() and _upnp.get_gateway().is_valid_gateway()):
		status = UpnpStatus.UNAVAILABLE
		push_error(str(res))
	print("Successfully mapped: ", port)

func _port_mapping_timer() -> void:
	if status == UpnpStatus.UNAVAILABLE:
		_timer.queue_free()
		return
	if _thread.is_started():
		return
	_thread.start(_port_mapping, Thread.PRIORITY_LOW)

func _discover() -> UPNP.UPNPResult:
	print_debug("Starting UPnP Discovery")
	var res: UPNP.UPNPResult = _upnp.discover(NetworkConfig.UPNP_TIMEOUT) as UPNP.UPNPResult
	
	call_deferred("_discover_done")
	return res

func _discover_done() -> void:
	var res: UPNP.UPNPResult = _thread.wait_to_finish()
	
	if res != UPNP.UPNP_RESULT_SUCCESS or !(_upnp.get_gateway() and _upnp.get_gateway().is_valid_gateway()):
		status = UpnpStatus.UNAVAILABLE
		push_warning("Unable to use UPnP defaulting to local on port: ", NetworkConfig.DEFAUL_PORT)
		return
	_port_mapping_timer()
	_timer.start(NetworkConfig.UPNP_TIMER)

func _ready() -> void:
	if multiplayer.is_server():
		return
	_upnp = UPNP.new()
	_thread = Thread.new()
	_timer.timeout.connect(_port_mapping_timer)
	_thread.start(_discover, Thread.PRIORITY_LOW)

func _exit_tree():
	if multiplayer.is_server():
		return
	_thread.wait_to_finish()
