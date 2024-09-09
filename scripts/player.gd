extends CharacterBody2D

#current speed of player
const SPEED = 200.0
@onready var player: CharacterBody2D = $"."
var firstPos
const hoseLimit = Vector2(100.0,100.0)

func _draw() -> void:
	#this draws the line for the hose
	draw_line(player.global_position, firstPos, Color.AQUA, float(4.0))
	
func _ready() -> void:
	#gets first player instance
	firstPos = player.global_position
	
#calculate whether the player can still move after a distance
func canMoveUp():
	var currpos = player.global_position
	if (-hoseLimit.y <= currpos.y):
		return true
	else:
		return false
		
func canMoveDown():
	var currpos = player.global_position
	if (hoseLimit.y >= currpos.y):
		return true
	else:
		return false
		
func canMoveLeft():
	var currpos = player.global_position
	if (-hoseLimit.x <= currpos.x):
		return true
	else:
		return false
		
func canMoveRight():
	var currpos = player.global_position
	if (hoseLimit.x >= currpos.x):
		return true
	else:
		return false

#dictates player movement
func _playerMovement() -> void:
	# Get the input direction and handle the movement/deceleration..
	var directionx := Input.get_axis("moveLeft", "moveRight")
	var directiony := Input.get_axis("moveUp", "moveDown")
	
	#player movement, checks if it can move in one direction
	if directionx or directiony:
		if (directionx < 0 and canMoveLeft()):
			velocity.x = directionx * SPEED
		if (directionx > 0 and canMoveRight()):
			velocity.x = directionx * SPEED
		if (directiony < 0 and canMoveUp()):
			velocity.y = directiony * SPEED
		if (directiony > 0 and canMoveDown()):
			velocity.y = directiony * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _physics_process(delta: float) -> void:
	canMoveDown()
	canMoveUp()
	canMoveRight()
	canMoveLeft()
	_playerMovement()
	queue_redraw()
	print(firstPos)
	print(player.global_position)
