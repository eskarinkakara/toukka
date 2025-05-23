extends Node3D

@export var background_scene: PackedScene
@export var segment_length: float = 200.0
@export var move_speed_multiplier: float = 1
@export var y_level: float = -25.0
@export var num_segments: int = 3
@export var rotation_offset: Vector3 = Vector3(5.5, 61, -1.5)

var segments: Array[Node3D] = []

func _ready():
	# Spawn initial background segments
	for i in range(num_segments):
		var seg = background_scene.instantiate()
		add_child(seg)
		seg.global_transform.origin.z = -i * segment_length
		seg.global_transform.origin.y = y_level
		seg.rotation_degrees = rotation_offset
		segments.append(seg)

func _process(delta):
	for seg in segments:
		seg.global_translate(Vector3(0, 0, (Global.move_speed*move_speed_multiplier) * delta))

	# Check if the first segment moved past the camera
	var first_seg = segments[0]
	if first_seg.global_transform.origin.z > segment_length:
		# Move it to the back instead of destroying (object pooling)
		var last_seg = segments[segments.size() - 1]
		first_seg.global_transform.origin.z = last_seg.global_transform.origin.z - segment_length
		# Rotate array
		segments.push_back(segments.pop_front())
