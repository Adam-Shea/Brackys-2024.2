extends CharacterBody2D

#current speed of player
const SPEED = 200.0
@onready var player: CharacterBody2D = $"."
var shootDir = Vector2(0,0)
var lastDir = Vector2(0,0)
var hoseCenter = Vector2(0.0,0.0)
const hoseRadius = 100

func _draw() -> void:
	#this draws the line for the hose
	var currpos = player.global_position
	draw_line(-player.global_position, hoseCenter, 
	# Generate colour of line. Closer to center, the greener the line should be
	Color(
	sqrt(pow(currpos.x - hoseCenter.x,2) + pow(currpos.y - hoseCenter.y, 2))/hoseRadius,
	1 - (sqrt(pow(currpos.x - hoseCenter.x,2) + pow(currpos.y - hoseCenter.y, 2))/hoseRadius),
	0,
	1), float(4.0))

	if(shootDir.x == 1):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = 0
	elif(shootDir.x == -1):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = 180
	elif(shootDir.y == 1):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = 90
	elif(shootDir.y == -1):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = 270
	else:
		$GPUParticles2D.emitting = false

	
func _ready() -> void:
	#gets first player instance
	hoseCenter = player.global_position
	
#calculate whether the player can still move after a distance
func isWithinHoseRadius(x,y):
	var currpos = player.global_position
	if(sqrt(pow(currpos.x - hoseCenter.x + x,2) + pow(currpos.y - hoseCenter.y + y, 2))<=hoseRadius):
		return true
	else:
		return false

#dictates player movement
func _playerMovement() -> void:
	# Get the input direction and handle the movement/deceleration..
	var directionx := Input.get_axis("moveLeft", "moveRight")
	var directiony := Input.get_axis("moveUp", "moveDown")
	
	#player movement, checks if it can move in one direction
	if (directionx < 0 and isWithinHoseRadius(-5,0)):
		if(!Input.is_action_pressed("shootWater")):
			lastDir = Vector2(-1,0)
		velocity.x = directionx * SPEED
	elif (directionx > 0 and isWithinHoseRadius(5,0)):
		if(!Input.is_action_pressed("shootWater")):
			lastDir = Vector2(1,0)
		velocity.x = directionx * SPEED
	elif (directiony < 0 and isWithinHoseRadius(0,-5)):
		if(!Input.is_action_pressed("shootWater")):
			lastDir = Vector2(0,-1)
		velocity.y = directiony * SPEED
	elif (directiony > 0 and isWithinHoseRadius(0,5)):
		if(!Input.is_action_pressed("shootWater")):
			lastDir = Vector2(0,1)
		velocity.y = directiony * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
			
	move_and_slide()

func _shootWater() -> void:
	if(Input.is_action_just_pressed("shootWater")):
		shootDir = lastDir
	if(Input.is_action_just_released("shootWater")):
		shootDir = Vector2(0,0)

func _physics_process(delta: float) -> void:
	_playerMovement()
	_shootWater()
	queue_redraw()
	#print(firstPos)
	#print(player.global_position)
