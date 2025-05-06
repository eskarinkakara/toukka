extends CharacterBody3D
var animation_player : AnimationPlayer

@export var lane_offset := 1.0              # Distance between lanes
@export var total_lanes := 3                # Should be an odd number (so there's a center lane)
@export var jump_velocity := 4.5            # Jump speed
@export var gravity := 10.0                 # Gravity force
var current_lane := 0                       # 0 = center, -1 = left, 1 = right


func _ready():
	animation_player = $AnimationPlayer

func _physics_process(delta):
	if is_on_floor() and animation_player.current_animation != "mantis_walk":
		animation_player.speed_scale = 2.0
		animation_player.play("mantis_run")
	# Handle input (one press per frame)
	if Input.is_action_just_pressed("move_left"):
		print("Move left")
		if animation_player.current_animation != "mantis_death":
			animation_player.play("mantis_walk")
		if Global.paihtynyt:
			current_lane += 1
		else:
			current_lane -= 1
	elif Input.is_action_just_pressed("move_right"):
		print("Move right")
		if animation_player.current_animation != "mantis_death":
			animation_player.play("mantis_walk")
		if Global.paihtynyt:
			current_lane -= 1
		else:
			current_lane += 1
	elif Input.is_action_just_pressed("move_jump"):
		if is_on_floor():
			print("Move jump")
			velocity.y = jump_velocity		# Set jump velocity
			animation_player.speed_scale = 2.0
			animation_player.play("mantis_death")

	# Clamp to available lanes
	var half = (total_lanes - 1) / 2
	current_lane = clamp(current_lane, -half, half)

	# Calculate desired X position
	var target_x = current_lane * lane_offset
	# Smooth movement to lane
	global_position.x = lerp(global_position.x, target_x, delta * 10.0)

	# Apply gravity
	velocity.y -= gravity * delta

	# Move the character
	move_and_slide()
