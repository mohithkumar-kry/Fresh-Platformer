extends Node2D
@onready var player: CharacterBody2D = $"../../Player"
@onready var self_area = self
@onready var player_area = $"../../Player/Area2D"

signal garlic_collected

var collected = false  # <-- new: tracks state independent of visibility

func _process(_delta: float) -> void:
	if collected:
		return  # already collected, skip everything below

	if player_area.overlaps_area(self_area):
		collected = true
		emit_signal("garlic_collected")
		get_parent().hide()
		set_deferred("monitoring", false)  # stop detecting overlap entirely
