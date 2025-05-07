extends Node3D

@export var prefab: PackedScene
@export var lane_offset := 1.0
@export var total_lanes := 3
@export var spawn_z := -25.0
@export var spawn_interval_range := Vector2(0.5, 2.0)
@export var move_speed := 10.0  # Speed to apply to each spawned object

var spawn_timer := 0.0
var next_spawn_time := 1.0

func _ready():
	randomize()
	_set_random_spawn_time()

func _process(delta):
	spawn_timer += delta
	if spawn_timer >= next_spawn_time:
		spawn_timer = 0.0
		_set_random_spawn_time()
		_spawn_random_object()

func _set_random_spawn_time():
	next_spawn_time = randf_range(spawn_interval_range.x, spawn_interval_range.y)

func _spawn_random_object():
	if not prefab:
		return

	var obj = prefab.instantiate()
	add_child(obj)

	var half = (total_lanes - 1) / 2
	var random_lane = randi_range(-half, half)
	var x_pos = random_lane * lane_offset

	obj.global_position = Vector3(x_pos, 0.5, spawn_z)

	# Pass move speed if the object supports it
	if "move_speed" in obj:
		obj.move_speed = move_speed
