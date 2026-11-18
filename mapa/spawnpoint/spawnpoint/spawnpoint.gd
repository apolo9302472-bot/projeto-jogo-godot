extends Node2D


@export var inimigo: PackedScene

var inimigo_criado = false

@onready var marker = $Marker2D
@onready var area = $Area2D


func _ready():
	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body.is_in_group("Player") and not inimigo_criado:
		inimigo_criado = true
		call_deferred("spawn_inimigo")


func spawn_inimigo():
	if inimigo == null:
		push_error("Nenhuma cena de inimigo foi configurada!")
		return

	var novo_inimigo = inimigo.instantiate()

	get_tree().current_scene.add_child(novo_inimigo)

	novo_inimigo.global_position = marker.global_position
