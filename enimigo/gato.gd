extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const KNOCKBACK_FORCE = 300.0

var health := 3
var isDead := false
var knockback_velocity := Vector2.ZERO


func _physics_process(delta: float) -> void:
	if isDead:
		return

	# GRAVIDADE
	if not is_on_floor():
		velocity += get_gravity() * delta

	# KNOCKBACK
	if knockback_velocity.length() > 0:
		velocity.x = knockback_velocity.x
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 1000.0 * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, 200.0 * delta)

	move_and_slide()


# RECEBER DANO
func take_damage(amount: int = 1, attacker_position: Vector2 = Vector2.ZERO) -> void:
	if isDead:
		return

	health -= amount
	print("Vida do inimigo: ", health)

	if attacker_position != Vector2.ZERO:
		var direction = (global_position - attacker_position).normalized()
		knockback_velocity = direction * KNOCKBACK_FORCE

	if health <= 0:
		die()


# MORTE
func die() -> void:
	isDead = true
	velocity = Vector2.ZERO
	queue_free()
