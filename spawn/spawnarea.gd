
extends Node2D

@export var inimigo: PackedScene

# Configurações do spawn
@export var intervalo_spawn: float = 3.0
@export var distancia_minima: float = 150.0
@export var distancia_maxima: float = 350.0

var spawn_ativo = false

@onready var start_area = $StartArea
@onready var end_area = $EndArea
@onready var timer = $Timer


func _ready():
	randomize()

	timer.wait_time = intervalo_spawn

	start_area.body_entered.connect(_on_start_entered)
	end_area.body_entered.connect(_on_end_entered)

	timer.timeout.connect(_on_timer_timeout)


# Jogador entrou na região
func _on_start_entered(body):
	if body.is_in_group("Player") and not spawn_ativo:
		spawn_ativo = true
		timer.start()


# Jogador chegou ao final
func _on_end_entered(body):
	if body.is_in_group("Player"):
		spawn_ativo = false
		timer.stop()


# Timer terminou
func _on_timer_timeout():
	if spawn_ativo:
		spawn_inimigo()


# Criar inimigo
func spawn_inimigo():
	if inimigo == null:
		push_error("Cena do inimigo não configurada!")
		return

	var jogador = get_tree().get_first_node_in_group("Player")

	if jogador == null:
		return

	# Descobrir direção do jogador
	var direcao = sign(jogador.velocity.x)

	# Se estiver parado, considera a direita
	if direcao == 0:
		direcao = 1

	# Escolher distância aleatória
	var distancia = randf_range(
		distancia_minima,
		distancia_maxima
	)

	# Calcular posição do inimigo
	var posicao = jogador.global_position

	# Aparecer na frente do jogador
	posicao.x += distancia * direcao

	# Manter a mesma altura do jogador
	posicao.y = jogador.global_position.y

	# Criar inimigo
	var novo_inimigo = inimigo.instantiate()

	get_tree().current_scene.add_child(novo_inimigo)

	novo_inimigo.global_position = posicao
