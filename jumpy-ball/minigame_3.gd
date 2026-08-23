extends Node2D

@onready var star_spawner: Timer = $StarSpawner
@onready var beam_spawner: Timer = $BeamSpawner
@onready var container: Node2D = self

var falling_star_scene := preload("res://falling_star.tscn")
var side_beam_scene := preload("res://side_beam.tscn")

var survive_time := 0.0
var target_time := 20.0

func _ready() -> void:
	star_spawner.wait_time = 0.6
	star_spawner.timeout.connect(_spawn_star)
	star_spawner.start()
	
	beam_spawner.wait_time = 1.2
	beam_spawner.timeout.connect(_spawn_beam)
	beam_spawner.start()

func _spawn_star() -> void:
	var star = falling_star_scene.instantiate()
	star.global_position = Vector2(randf_range(420, 780), 190)  # spawn just above battle box
	container.add_child(star)

func _spawn_beam() -> void:
	var beam = side_beam_scene.instantiate()
	var from_left := randf() > 0.5
	var y_pos = randf_range(220, 480)
	if from_left:
		beam.global_position = Vector2(390, y_pos)
		beam.direction = 1.0
	else:
		beam.global_position = Vector2(810, y_pos)
		beam.direction = -1.0
	container.add_child(beam)

func _process(delta: float) -> void:
	survive_time += delta
	
	if survive_time >= target_time:
		if Global.minigames_done > 3:
			get_tree().change_scene_to_file("res://done_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://timer_screen.tscn")
	
	if Global.lives <= 0:
		get_tree().change_scene_to_file("res://timer_screen.tscn")
