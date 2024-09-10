extends Node2D
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	print(player.health)
	player.health -= 20
	print(player.health)

func fireDamage():
	player.health -= 20
	print(player.health)
