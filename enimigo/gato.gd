extends CharacterBody2D


@export var speed: float = 100.0
@export var attack_distance: float = 30.0
@export var attack_cooldown: float = 1.0

var player: Node2D
var can_attack: bool = true


func _ready() -> void:

	player = get_tree().get_first_node_in_group("Player")


func _physics_process(_delta: float) -> void:

	if player == null:
		return


	# ==============================
	# MOVIMENTO ATÉ O PLAYER
	# ==============================

	var direction = global_position.direction_to(
		player.global_position
	)

	velocity = direction * speed
extends CharacterBody2D

@export var speed: float = 100.0
@export var attack_distance: float = 30.0
@export var attack_cooldown: float = 1.0

var player: Node2D
var can_attack: bool = true


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")


func _physics_process(_delta: float) -> void:

	if player == null:
		return

	# Persegue o jogador
	var direction = global_position.direction_to(
		player.global_position
	)

	velocity = direction * speed

	move_and_slide()

	# Ataca quando chega perto
	if global_position.distance_to(player.global_position) <= attack_distance:
		attack_player()


# ==========================================
# ATAQUE DO INIMIGO
# ==========================================

func attack_player() -> void:

	if not can_attack:
		return

	can_attack = false

	if player.has_method("take_damage"):
		player.take_damage(global_position)

	await get_tree().create_timer(
		attack_cooldown
	).timeout

	can_attack = true


# ==========================================
# RECEBER ATAQUE
# ==========================================

func take_damage(_attacker_position: Vector2 = Vector2.ZERO) -> void:

	print("Inimigo foi atingido!")

	# Remove o inimigo da cena
	queue_free()
	move_and_slide()


	# ==============================
	# ATAQUE
	# ==============================

	if global_position.distance_to(
		player.global_position
	) <= attack_distance:

		attack_player()


func attack_player() -> void:

	if not can_attack:
		return

	can_attack = false


	# ==============================
	# CAUSAR DANO
	# ==============================

	if player.has_method("take_damage"):

		player.take_damage(
			global_position
		)


	# ==============================
	# COOLDOWN
	# ==============================

	await get_tree().create_timer(
		attack_cooldown
	).timeout

	can_attack = true
	
