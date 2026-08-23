extends CharacterBody2D

@export var speed := 400.0
@export var speed_increase := 20.0
@export var max_speed := 1000.0
var direction := Vector2.ZERO
@onready var screen_size: Vector2 = Vector2(1152, 648)
var can_move := false

func _ready() -> void:
	reset_ball()

func _physics_process(_delta: float) -> void:
	if not can_move:
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
			can_move = true
			velocity = direction * speed
		return

	var motion = velocity * _delta
	var bounces = 0
	while bounces < 4:
		var collision = move_and_collide(motion)
		if collision == null:
			break
		
		var normal = collision.get_normal()
		velocity = velocity.bounce(normal)
		motion = collision.get_remainder().bounce(normal)
		
		var collider = collision.get_collider()
		if collider.is_in_group("paddle"):
			speed = min(speed + speed_increase, max_speed)
			velocity = velocity.normalized() * speed
		
		bounces += 1
	
	global_position.y = clamp(global_position.y, 10, screen_size.y - 10)
	
	if global_position.x < 0:
		Global.ai_score += 1
		reset_ball(-1)
	elif global_position.x > screen_size.x:
		Global.player_score += 1
		reset_ball(1)

func reset_ball(dir_x: int = 1) -> void:
	global_position = screen_size / 2
	direction = Vector2(dir_x, randf_range(-0.5, 0.5)).normalized()
	can_move = false
	velocity = Vector2.ZERO
