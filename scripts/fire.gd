extends Node2D

const replicateLimit = 5;
const replicationSpeed = 5;
const maxNodesInTree = 100;
var rng = RandomNumberGenerator.new()
var health = 100;
var replicationCount = 0;
var Fire = load("res://scenes/fire.tscn")
@onready var game_manager: Node = $"../%GameManager"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spreadTimer()

func spreadTimer() -> void:
	while (health > 0 && replicationCount <= replicateLimit && get_parent().get_child_count() <= maxNodesInTree):
		await get_tree().create_timer(rng.randf_range(replicationSpeed, replicationSpeed+2)).timeout
		spreadLogic()

func spreadLogic() -> void:
	replicationCount += 1
	var newFire = Fire.instantiate() 
	newFire.set_name("Fire")
	newFire.game_manager = game_manager
	newFire.position = global_position+Vector2(rng.randf_range(-20.0, 20.0),rng.randf_range(-20.0, 20.0))
	get_parent().add_child(newFire, true)

# Damaging the player when they enter the fire
func _on_body_entered(body: Node2D) -> void:
	if (body.name.match("Player")):
		body.handleDamageTaken(1,
		Vector2((global_position+get_node("CollisionShape2D").shape.size).x-(body.global_position+body.get_node("CollisionShape2D").shape.size).x,
		(global_position+get_node("CollisionShape2D").shape.size).y-(body.global_position+body.get_node("CollisionShape2D").shape.size).y))
		game_manager.fireDamage()
		

func _physics_process(delta: float) -> void:
	if (health <=0):
		queue_free()
