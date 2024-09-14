extends Area2D
@onready var gameManager = %GameManager
@onready var game = $"../../"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (gameManager.collectedCats == gameManager.totalCats):
		$AnimatedSprite2D.animation="open"


func _on_body_entered(body: Node2D) -> void:
	if	(body.name=="Player" && gameManager.collectedCats == gameManager.totalCats):
		game.endLevel(gameManager.firesDestroyed)
