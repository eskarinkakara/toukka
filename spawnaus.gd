extends Node3D

@export var prefab: PackedScene
@export var lane_offset := 1.0
@export var total_lanes := 3
@export var spawn_z := -50.0
@export var spawn_interval_range := Vector2(0.5, 2.0)
@export var move_speed := 10.0  # Starting move speed

var spawn_timer := 0.0
var next_spawn_time := 1.0
var survival_time := 0.0

func _ready():
	randomize()
	_set_random_spawn_time()

func _process(delta):
	survival_time += delta
	move_speed += survival_time / 10000.0

	spawn_timer += delta
	if spawn_timer >= next_spawn_time:
		spawn_timer = 0.0
		_set_random_spawn_time()
		_spawn_random_object()

func _set_random_spawn_time():
	# Dynamically scale spawn rate based on move_speed
	var speed_factor = clamp(move_speed / 10.0, 1.0, 20.0)  # Normalize around default speed
	var adjusted_min = spawn_interval_range.x / speed_factor
	var adjusted_max = spawn_interval_range.y / speed_factor
	next_spawn_time = randf_range(adjusted_min, adjusted_max)

func _spawn_random_object():
	if not prefab:
		return

	var obj = prefab.instantiate()
	add_child(obj)

	var half = (total_lanes - 1) / 2
	var random_lane = randi_range(-half, half)
	var x_pos = random_lane * lane_offset

	obj.global_position = Vector3(x_pos, 0.1, spawn_z)

	# Pass move speed if the object supports it
	if "move_speed" in obj:
		obj.move_speed = move_speed
