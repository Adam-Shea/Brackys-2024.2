extends Node
@onready var player: CharacterBody2D = $"../Player"
@onready var heart: Node2D = $"../Player/CanvasLayer/heart"
@onready var heart_2: Node2D = $"../Player/CanvasLayer/heart2"
@onready var heart_3: Node2D = $"../Player/CanvasLayer/heart3"
var firesDestroyed = 0
var hasIFrames: bool = false
var totalCats = 0
var collectedCats = 0
@onready var game_over_label: Label = $"../Player/CanvasLayer/GameOverLabel"
@onready var catCounter: Label = $"../Player/CanvasLayer/CatCounter"
@onready var timer: Timer = $"../Player/CanvasLayer/Timer"


func _ready() -> void:
	game_over_label.visible = false
	for i in get_parent().get_children():
		if (i.name.left(3) == "Cat") :
			totalCats += 1
	catCounter.text = "0/" + str(totalCats)

func increaseCatCount() -> void:
	collectedCats += 1
	catCounter.text = str(collectedCats)+"/" + str(totalCats)


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
			game_over_label.visible = true
			game_over_label.text = "Nice try, firefighter"
			player.stopMoving()
			timer.start()
		hasIFrames = true
	
		for i in 6:
			player.modulate.a = 0.5
			await get_tree().create_timer(0.05).timeout
			player.modulate.a = 1.0
			await get_tree().create_timer(0.05).timeout
		
		hasIFrames = false
