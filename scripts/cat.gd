extends Area2D
@onready var gameManager = %GameManager


# Called when the node enters the qscene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if (body.name=="Player"):
		gameManager.increaseCatCount();
		queue_free()
