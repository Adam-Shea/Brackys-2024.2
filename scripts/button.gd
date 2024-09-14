extends Node2D

var firesDestroyed = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Camera2D/fire_count.text = str(firesDestroyed)+" x"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	$"../".nextLevel()
