extends Node2D

const replicateLimit = 5;
const replicationSpeed = 5;
const maxNodesInTree = 100;
var rng = RandomNumberGenerator.new()
var health = 100;
var replicationCount = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spreadTimer()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spreadTimer() -> void:
	while (health > 0 && replicationCount <= replicateLimit && get_parent().get_child_count() <= maxNodesInTree):
		await get_tree().create_timer(rng.randf_range(replicationSpeed, replicationSpeed+2)).timeout
		spreadLogic()

func spreadLogic() -> void:
	replicationCount += 1
	var newFire = $".".duplicate()
	newFire.position = global_position+Vector2(rng.randf_range(-20.0, 20.0),rng.randf_range(-20.0, 20.0))
	add_sibling(newFire)
