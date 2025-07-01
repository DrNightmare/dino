extends Area2D
class_name Obstacle

const x_out_of_bounds_threshold = -30
@export var SPEED = 200
@export var spawn_height = 0
var is_active: bool = true

func set_is_active(new_value: bool):
	is_active = new_value

func _process(delta: float) -> void:
	if not is_active:
		return
	position.x -= SPEED * delta
	if position.x < x_out_of_bounds_threshold:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		SignalBus.death.emit()
