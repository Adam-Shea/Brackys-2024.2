extends CharacterBody2D

#current speed of player
const SPEED = 200.0

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration..
	var directionx := Input.get_axis("moveLeft", "moveRight")
	var directiony := Input.get_axis("moveUp", "moveDown")
	
	#we only want on to move on one axis at a time technically
	if directionx or directiony:
		velocity.x = directionx * SPEED
		velocity.y = directiony * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
