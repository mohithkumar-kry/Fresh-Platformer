extends Area2D

# Emitted when the player jumps on top of this mushroom
signal stomped(mushroom)
# Emitted when this mushroom touches the player from the side (not stomped)
signal hit_player(mushroom)

@export var speed: float = 140.0
@export var bounce_velocity: float = -350.0
# how far above the mushroom's center the player's origin must be
# (while falling) for it to count as a stomp instead of a hit
@export var stomp_threshold: float = 10.0

var _has_reacted := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.x -= speed * delta
	# clean up once it's scrolled well off the left side of the screen
	if position.x < -100.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if _has_reacted:
		return
	if not (body is CharacterBody2D):
		return

	var is_falling: bool = body.velocity.y > 0
	var is_above: bool = body.global_position.y < global_position.y - stomp_threshold

	if is_falling and is_above:
		_has_reacted = true
		body.velocity.y = bounce_velocity
		stomped.emit(self)
		_squash_and_remove()
	else:
		if body.has_method("is_immune") and body.is_immune():
			return  # player is currently blinking/invincible, ignore this contact
		_has_reacted = true
		hit_player.emit(self)
		if body.has_method("hurt"):
			var dir_away: float = sign(body.global_position.x - global_position.x)
			if dir_away == 0.0:
				dir_away = -1.0
			body.hurt(dir_away)
		# mushroom keeps sliding through the player per design;
		# it will free itself once off-screen (see _process above)

func _squash_and_remove() -> void:
	set_deferred("monitoring", false)
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2(1.0, 0.2), 0.15)
	tween.parallel().tween_property(self, "position:y", position.y + 10, 0.15)
	tween.tween_callback(queue_free)
