extends Area2D

@export var speed := 300.0
@export var box_min := Vector2(400, 200)
@export var box_max := Vector2(800, 500)

func _process(delta: float) -> void:
	var dir := Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	
	global_position += dir.normalized() * speed * delta
	global_position.x = clamp(global_position.x, box_min.x, box_max.x)
	global_position.y = clamp(global_position.y, box_min.y, box_max.y)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectile"):
		Global.lives -= 1
		area.queue_free()
