extends Area2D

@export var speed := 350.0
var direction := 1.0  # 1 = moving right, -1 = moving left

func _process(delta: float) -> void:
	global_position.x += speed * direction * delta
	if global_position.x < -50 or global_position.x > 1200:
		queue_free()
