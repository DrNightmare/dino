extends CharacterBody2D
class_name Dino

const JUMP_VELOCITY = -450.0
const FALL_MULTIPLIER = 1.75
var is_active: bool = true

enum State { NORMAL, DUCKING }
var current_state: State = State.NORMAL

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var normal_collision_shape_2d: CollisionShape2D = $NormalCollisionShape2D
@onready var normal_collision_shape_2d_2: CollisionShape2D = $NormalCollisionShape2D2
@onready var ducked_collision_shape_2d: CollisionShape2D = $DuckedCollisionShape2D


func get_gravity_to_apply():
	# if falling, multiplier
	if velocity.y > 0:
		return get_gravity() * FALL_MULTIPLIER
	return get_gravity()

func set_animation():
	animated_sprite_2d.animation = 'move_ducking' if current_state == State.DUCKING else 'move'

func set_collision_shapes():
	normal_collision_shape_2d.disabled = current_state == State.DUCKING
	normal_collision_shape_2d_2.disabled = current_state == State.DUCKING
	ducked_collision_shape_2d.disabled = current_state == State.NORMAL

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	var gravity_to_apply = get_gravity_to_apply()
	# Add the gravity.
	
	var floored = is_on_floor()
	if not floored:
		velocity += gravity_to_apply * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and floored:
		velocity.y = JUMP_VELOCITY
		
	# if ducking, set sprite accordingly
	current_state = State.DUCKING if Input.is_action_pressed("duck") and floored else State.NORMAL
	set_animation()
	set_collision_shapes()

	# Jump cut
	if Input.is_action_just_released("jump"):
		# if climbing do jump cut
		if velocity.y < 0:
			velocity.y /= 2
	move_and_slide()

func set_is_active(new_value: bool):
	is_active = new_value
	if not is_active:
		animated_sprite_2d.stop()
	else:
		animated_sprite_2d.play()
