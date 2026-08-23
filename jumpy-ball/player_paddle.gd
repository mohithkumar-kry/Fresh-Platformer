extends CharacterBody2D

@export var speed := 500.0
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size

func _physics_process(_delta: float) -> void:
	var direction := 0.0
	if Input.is_action_pressed("ui_up"):
		direction -= 1.0
	if Input.is_action_pressed("ui_down"):
		direction += 1.0
	
	velocity.y = direction * speed
	move_and_slide()
	global_position.y = clamp(global_position.y, 60, screen_size.y - 60)rint("Player Y: ", global_position.y)
