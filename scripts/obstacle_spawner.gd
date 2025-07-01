extends Node2D
class_name ObstacleSpawner

@export var obstacles_parent: Node
@export var possible_obstacles: Array[PackedScene]
@export_range(2000, 2200) var spawn_x_position = 2000
@onready var spawn_timer: Timer = $SpawnTimer

var is_active: bool = true
@export var speed_increment_per_second := 4.0
var base_speed: float = 400
const MAX_SPEED = 1000
const MIN_SPAWN_TIME = 0.85


func set_is_active(new_value: bool):
	is_active = new_value
	if not is_active:
		spawn_timer.stop()
	else:
		spawn_timer.start()

func _process(delta: float) -> void:
	if is_active:
		if base_speed <= MAX_SPEED:
			base_speed += speed_increment_per_second * delta
		
		if spawn_timer.wait_time >= MIN_SPAWN_TIME:
			spawn_timer.wait_time -= speed_increment_per_second * delta * 0.001

func _on_spawn_timer_timeout() -> void:
	var random_obstacle: PackedScene = possible_obstacles.pick_random()
	var instance = random_obstacle.instantiate()
	
	(instance as Obstacle).SPEED = base_speed
	
	if instance is Bird:
		# add little randomness to the height
		var offset := randf_range(0, 80)
		instance.spawn_height += offset

	instance.set_position(Vector2(spawn_x_position, 603 - instance.spawn_height))
	obstacles_parent.add_child(instance)
