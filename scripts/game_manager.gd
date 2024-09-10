extends Node2D
@onready var player: CharacterBody2D = $"../Player"

func fireDamage():
	player.health -= 20
	print(player.health)
