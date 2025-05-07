extends Node
var survival_time: float = 0.0
var valuutta: float = 0.0
var player_alive : bool = true
var paihtynyt: bool = false
var paihtynytStrength: float = 1.0
@export var drunk_duration: float = 5.0

var _drunk_timer: Timer = null

func set_paihtynyt(active: bool):
	paihtynyt = active
	if active:
		print("Päihtynyt")
		_start_or_restart_drunk_timer()
	else:
		print("ei päihtynyt (aikaisin)")
		paihtynytStrength = 0.9
		_stop_drunk_timer()

func _start_or_restart_drunk_timer():
	if _drunk_timer == null:
		_drunk_timer = Timer.new()
		_drunk_timer.one_shot = true
		_drunk_timer.connect("timeout", Callable(self, "_on_drunk_timeout"))
		add_child(_drunk_timer)
	else:
		paihtynytStrength += 0.1

	valuutta += 1 * paihtynytStrength
	_drunk_timer.stop()  # Reset the countdown
	_drunk_timer.wait_time = drunk_duration
	_drunk_timer.start()
	print("Multiplier: ", paihtynytStrength)
	print("Valuutta: ", valuutta)

func _stop_drunk_timer():
	if _drunk_timer != null:
		_drunk_timer.stop()

func _on_drunk_timeout():
	paihtynyt = false
	paihtynytStrength = 0.9
	print("ei päihtynyt")

# Called every frame to update the player's survival time.
func _process(delta):
	if Global.player_alive:
		survival_time += delta
		survival_time = round(survival_time * 10) / 10.0
