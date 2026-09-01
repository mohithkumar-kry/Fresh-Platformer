extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

const HURT_KNOCKBACK_SPEED = 260.0
const HURT_JUMP_VELOCITY = -320.0
const HURT_DURATION = 0.35

const INVINCIBILITY_DURATION = 1.0
const BLINK_INTERVAL = 0.1

@onready var sprite := $AnimatedSprite2D

var is_hurt := false
var hurt_timer := 0.0

var is_invincible := false
var invincible_timer := 0.0
var blink_timer := 0.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	_update_invincibility(delta)

	if is_hurt:
		hurt_timer -= delta
		if hurt_timer <= 0.0:
			is_hurt = false
		# let the knockback play out without normal input fighting it,
		# but let horizontal speed bleed off naturally
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.5 * delta * 10)
		move_and_slide()
		update_animation()
		return

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	update_animation()

func update_animation() -> void:
	if not is_on_floor():
		sprite.play("Jump")
	elif abs(velocity.x) > 1.0:
		sprite.play("Run")
	else:
		sprite.play("idel")

# Called by mushroom.gd when the player is hit (not stomped).
# knockback_dir: -1.0 = push left, 1.0 = push right
func hurt(knockback_dir: float) -> void:
	is_hurt = true
	hurt_timer = HURT_DURATION
	velocity.x = knockback_dir * HURT_KNOCKBACK_SPEED
	velocity.y = HURT_JUMP_VELOCITY

	is_invincible = true
	invincible_timer = INVINCIBILITY_DURATION
	blink_timer = 0.0

# Mushroom checks this before applying a hit, so you can't get hurt
# again mid-blink from the same or another overlapping mushroom.
func is_immune() -> bool:
	return is_invincible

func _update_invincibility(delta: float) -> void:
	if not is_invincible:
		return
	invincible_timer -= delta
	if invincible_timer <= 0.0:
		is_invincible = false
		sprite.visible = true
		return
	blink_timer -= delta
	if blink_timer <= 0.0:
		blink_timer = BLINK_INTERVAL
		sprite.visible = not sprite.visible
