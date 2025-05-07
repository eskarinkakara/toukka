extends Node3D

@export var move_speed: float = 10.0
@export var rotation_speed: Vector3 = Vector3(0, 180, 30)
@export var destroy_z_threshold: float = 25.0
@export_enum("olut", "crow") var pickup_type: String = "olut"

func _ready():
	# Connect the Area3D's signal
	$Area3D.body_entered.connect(_on_body_entered)

func _process(delta):
	global_translate(Vector3(0, 0, move_speed * delta))

	rotate_x(deg_to_rad(rotation_speed.x * delta))
	rotate_y(deg_to_rad(rotation_speed.y * delta))
	rotate_z(deg_to_rad(rotation_speed.z * delta))

	if global_position.z > destroy_z_threshold:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("Kerätty")
		_apply_pickup_effect(body)
		queue_free()

func _apply_pickup_effect(body):
	match pickup_type:
		"olut":
			Global.set_paihtynyt(true)
		"crow":
			Global.player_alive = false
			print("Pelaaja kuollut")
		_:
			print("Unknown pickup type")
