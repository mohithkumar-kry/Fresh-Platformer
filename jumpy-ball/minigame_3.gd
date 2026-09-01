extends Node2D

const MUSHROOM_SCENE := preload("res://mushroom.tscn")
const HITS_TO_LOSE := 3
const STOMPS_TO_WIN := 10

@onready var spawn_timer: Timer = $MushroomSpawnTimer
@onready var hits_label: Label = $HUD/HitsLabel
@onready var stomps_label: Label = $HUD/StompsLabel
@onready var themed_timer: Node2D = $ThemedTimer

@export var spawn_y: float = 400.0
@export var spawn_x: float = 900.0

var hits := 0
var stomps := 0
var game_over := false
var timer_end = false

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	_update_hud()
	await themed_timer.Timer(30.0)
	timer_end = true 

func _on_spawn_timer_timeout() -> void:
	if game_over:
		return
	_spawn_mushroom()

func _spawn_mushroom() -> void:
	var m := MUSHROOM_SCENE.instantiate()
	m.position = Vector2(spawn_x, spawn_y)
	m.speed = randf_range(110.0, 190.0)
	m.stomped.connect(_on_mushroom_stomped)
	m.hit_player.connect(_on_mushroom_hit_player)
	add_child(m)

func _on_mushroom_stomped(_m) -> void:
	if game_over:
		return
	stomps += 1
	_update_hud()
	
func _on_mushroom_hit_player(_m) -> void:
	if game_over:
		return
	hits += 1
	_update_hud()
	
func _update_hud() -> void:
	hits_label.text = "Hits: %d/%d" % [hits, HITS_TO_LOSE]
	stomps_label.text = "Stomps: %d/%d" % [stomps, STOMPS_TO_WIN]


func _process(delta: float) -> void:
	
	if stomps == 10:
		if Global.minigames_done > 3:
			get_tree().change_scene_to_file("res://Won_screen.tscn")
		else:
			get_tree().change_scene_to_file("res://timer_screen.tscn")
	elif hits == 3:
		get_tree().change_scene_to_file("res://timer_screen.tscn")
	
	if timer_end:
		Global.lives -= 1
		Global.minigames_done -=1
		get_tree().change_scene_to_file("res://timer_screen.tscn")
