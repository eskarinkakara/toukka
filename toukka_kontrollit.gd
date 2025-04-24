extends CharacterBody3D

@export var lane_offset := 1.0              # Distance between lanes
@export var total_lanes := 3                # Should be an odd number (so there's a center lane)

var current_lane := 0                       # 0 = center, -1 = left, 1 = right

func _physics_process(delta):
	# Handle input (one press per frame)
	if Input.is_action_just_pressed("move_left"):
		print("Move left")
		current_lane -= 1
	elif Input.is_action_just_pressed("move_right"):
		print("Move right")
		current_lane += 1

	# Clamp to available lanes
	var half = (total_lanes - 1) / 2
	current_lane = clamp(current_lane, -half, half)

	# Calculate desired X position
	var target_x = current_lane * lane_offset
	# Smooth movement to lane
	global_position.x = lerp(global_position.x, target_x, delta * 10.0)

	# Remove forward movement if not needed
	# velocity.z = -move_speed
	move_and_slide()
