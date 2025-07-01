extends Node2D

@onready var obstacles: Node = $Obstacles
@onready var obstacle_spawner: ObstacleSpawner = $ObstacleSpawner
@onready var menu: Control = $Menu
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@onready var score_label: Label = $ScoreLabel

var is_active: bool = true
var is_game_over: bool = false

func _ready() -> void:
	SignalBus.death.connect(handle_game_over)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_pause()

func handle_game_over():
	is_game_over = true
	set_active(false)

func toggle_pause():
	if is_game_over:
		return
	set_active(not is_active)

func set_active(new_value: bool):
	is_active = new_value
	(character_body_2d as Dino).set_is_active(new_value)
	obstacle_spawner.set_is_active(new_value)
	var all_obstacles = obstacles.get_children()
	for obstacle in all_obstacles:
		(obstacle as Obstacle).set_is_active(new_value)
	score_label.set_is_active(new_value)
	menu.set_visible(not new_value)
