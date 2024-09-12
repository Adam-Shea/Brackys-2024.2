extends Node2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func lostHealth():
	print("i have lost health")
	animated_sprite.play("nohealth")
