extends Node2D
@onready var player: CharacterBody2D = $"../Player"

func fireDamage():
	print(player.health)
	if (player.health > 1):
		player.health -= 1
	else:
		print("you died")
	
