extends Node

var spawn_radius: float

@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time: float


func _ready() -> void:
	base_spawn_time = timer.wait_time
	var viewport_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	if viewport_width > viewport_height:
		spawn_radius = viewport_width
	else:
		spawn_radius = viewport_height
	spawn_radius += 40
	
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	
	timer.timeout.connect(on_timer_timeout)


func on_timer_timeout():
	timer.start()
	
	var player: Node2D = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var random_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position: Vector2 = player.global_position + (random_direction * spawn_radius)
	
	var enemy: Node2D = basic_enemy_scene.instantiate()
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	if entities_layer == null:
		return
	
	entities_layer.add_child(enemy)
	enemy.global_position = spawn_position


func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1 / 12) * arena_difficulty
	time_off = min(time_off, .7)
	timer.wait_time = base_spawn_time - time_off
