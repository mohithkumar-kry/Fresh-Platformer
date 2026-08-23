extends CharacterBody2D

@export var speed := 350.0
@export var ball_path: NodePath
@onready var ball: CharacterBody2D = get_node(ball_path)
@onready var screen_size: Vector2 = Vector2(1152, 648)  # hardcoded, matches ball.gd

func _physics_process(_delta: float) -> void:
	var target_y = ball.global_position.y
	var direction := 0.0
	
	if global_position.y < target_y - 10:
		direction = 1.0
	elif global_position.y > target_y + 10:
		direction = -1.0
	
	velocity.y = direction * speed
	move_and_slide()
	global_position.y = clamp(global_position.y, 60, screen_size.y - 60)
