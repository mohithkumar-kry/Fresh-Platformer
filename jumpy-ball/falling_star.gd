extends Area2D

@export var fall_speed := 200.0

func _process(delta: float) -> void:
	global_position.y += fall_speed * delta
	if global_position.y > 700:
		queue_free()
