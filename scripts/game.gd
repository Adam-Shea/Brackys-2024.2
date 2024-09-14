extends Node2D
var currentLevel = 1;
var nextLevelScreen = load("res://scenes/next_level_screen.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func endLevel(firesDestroyed) -> void:
	for i in get_children():
		if (i.name.left(5)=="Level"):
			i.queue_free()
	var nextLevelScreenObject = nextLevelScreen.instantiate()
	nextLevelScreenObject.firesDestroyed = firesDestroyed
	add_child(nextLevelScreenObject, true)

func nextLevel() -> void:
	$NextLevelScreen.queue_free()
	currentLevel += 1
	var nextLevel = load("res://scenes/level" + str(currentLevel)+ ".tscn")
	var nextLevelObject = nextLevel.instantiate()
	add_child(nextLevelObject, true)

func reload() -> void:
	for i in get_children():
		if (i.name.left(5)=="Level"):
			i.queue_free()
	var nextLevel = load("res://scenes/level" + str(currentLevel)+ ".tscn")
	var nextLevelObject = nextLevel.instantiate()
	add_child(nextLevelObject, true)
