extends CharacterBody2D

#current speed of player
const SPEED = 200.0
@onready var player: CharacterBody2D = $"."
var firstPos
const hoseLimit = Vector2(100.0,100.0)
var shootDir = Vector2(0,0)
var lastDir = Vector2(0,0)
var hoseCenter = Vector2(0.0,0.0)
var connectedToSource = true
var hasIframes = false 
const hoseForgivenessRange = 10
const hoseRadius = 100
@export var health = 3

func _draw() -> void:
	#this draws the line for the hose
	var currpos = player.global_position
	
	if(connectedToSource):
		draw_line(-player.global_position + hoseCenter, Vector2(0,0), 
		# Generate colour of line. Closer to center, the greener the line should be
		Color(
		sqrt(pow(currpos.x - hoseCenter.x,2) + pow(currpos.y - hoseCenter.y, 2))/hoseRadius,
		1 - (sqrt(pow(currpos.x - hoseCenter.x,2) + pow(currpos.y - hoseCenter.y, 2))/hoseRadius),
		0,
		1), float(4.0))

	if(shootDir.x == 1):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = 0
		$RayCast2D.rotation_degrees = 0
	elif(shootDir.x == -1):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = 180
		$RayCast2D.rotation_degrees = 180
	elif(shootDir.y == 1):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = 90
		$RayCast2D.rotation_degrees = 90
	elif(shootDir.y == -1):
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = 270
		$RayCast2D.rotation_degrees = 270
	else:
		$GPUParticles2D.emitting = false

	
func _ready() -> void:
	#gets first player instance
	hoseCenter = player.global_position
	
#calculate whether the player can still move after a distance
func isWithinHoseRadius(x,y):
	if connectedToSource:
		var currpos = player.global_position
		if(sqrt(pow(currpos.x - hoseCenter.x + x,2) + pow(currpos.y - hoseCenter.y + y, 2))<=hoseRadius):
			return true
		else:
			return false
	else:
		return true

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

func disableWater() -> void:
	shootDir = Vector2(0,0)
	$RayCast2D.enabled = false

func _shootWater() -> void:
	if(Input.is_action_just_pressed("shootWater") && connectedToSource):
		shootDir = lastDir
		$RayCast2D.enabled = true
	if(Input.is_action_just_released("shootWater")):
		disableWater()
	
	if ($RayCast2D.enabled && $RayCast2D.is_colliding()):
		if ($RayCast2D.get_collider() && $RayCast2D.get_collider().name.left(4) == "Fire"):
			$RayCast2D.get_collider().health -= 1
			$RayCast2D.get_collider().scale.x *= 0.998
			$RayCast2D.get_collider().scale.y *= 0.998

func _diconnectSource() -> void:
	if(
		Input.is_action_just_released("interact") && 
		player.global_position.x < hoseCenter.x + hoseForgivenessRange &&
		player.global_position.x > hoseCenter.x - hoseForgivenessRange &&
		player.global_position.y > hoseCenter.y - hoseForgivenessRange &&
		player.global_position.y < hoseCenter.y + hoseForgivenessRange):
			connectedToSource = false
			disableWater()
	# Just so we can debug with multiple sources
	elif(Input.is_action_just_released("interact") && !connectedToSource):
		hoseCenter = player.global_position
		connectedToSource = true
			
func _on_body_entered():
	pass
	
func handleDamageTaken(damageAmount,vectorTo) -> void:
	if (!hasIframes):
		player.global_position.x -= vectorTo.x*1.5
		player.global_position.y -= vectorTo.y*1.5
		hasIframes = true
		health -= damageAmount
		if(health<=0):
			print("I'm dead")
		# if knockback is too far disconnect hose
		if(!isWithinHoseRadius(player.global_position.x,player.global_position.y)):
			connectedToSource = false
			disableWater()
			
		await get_tree().create_timer(2).timeout
		hasIframes = false

func _physics_process(delta: float) -> void:
	_playerMovement()
	_shootWater()
	_diconnectSource()
	queue_redraw()
	#print(firstPos)
	#print(player.global_position)
