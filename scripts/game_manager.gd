extends Node
@onready var player: CharacterBody2D = $"../Player"
@onready var heart: Node2D = $"../Player/Camera2D/heart"
@onready var heart_2: Node2D = $"../Player/Camera2D/heart2"
@onready var heart_3: Node2D = $"../Player/Camera2D/heart3"
var hasIFrames: bool = false

func fireDamage():
	if (!hasIFrames):
		player.connectedToSource = false
		player.disableWater()
		if (player.health > 1):
			player.health -= 1
			if player.health == 2:
				heart_3.lostHealth()
			elif player.health == 1:
				heart_2.lostHealth()
		else:
			heart.lostHealth()
			print("you died")
		hasIFrames = true
	
		for i in 6:
			player.modulate.a = 0.5
			await get_tree().create_timer(0.05).timeout
			player.modulate.a = 1.0
			await get_tree().create_timer(0.05).timeout
		
		hasIFrames = false
	
