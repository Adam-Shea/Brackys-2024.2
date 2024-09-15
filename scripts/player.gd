extends CharacterBody2D

#current speed of player
const SPEED = 130.0
@onready var player: CharacterBody2D = $"."
var firstPos
const hoseLimit = Vector2(100.0,100.0)
var lastDir = Vector2(0,0)
var hoseCenter = Vector2(0.0,0.0)
var nextWaterSource = Vector2(0,0)
var connectedToSource = false
var hasIframes := false 
var canPlaceSource = false
var shootingWater = false
const hoseForgivenessRange = 10
const hoseRadius = 100
@export var health = 3
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var canMove := true


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

	if (shootingWater && connectedToSource): 
		$GPUParticles2D.emitting = true
		$GPUParticles2D.rotation_degrees = rad_to_deg(get_angle_to(get_global_mouse_position()))
		$RayCast2D.rotation_degrees = rad_to_deg(get_angle_to(get_global_mouse_position()))
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
	if canMove:
		var directionx := Input.get_axis("moveLeft", "moveRight")
		var directiony := Input.get_axis("moveUp", "moveDown")

		#set up animation for either walking or idle
		if directionx or directiony:
			animated_sprite.play("walking")
		else:
			animated_sprite.play("idle")

		var newVel = Vector2(0,0)
		if (directionx < 0 and isWithinHoseRadius(-5,0)):
			newVel.x = directionx * SPEED
		if (directionx > 0 and isWithinHoseRadius(5,0)):
			newVel.x = directionx * SPEED
		if (directiony < 0 and isWithinHoseRadius(0,-5)):
			newVel.y = directiony * SPEED
		if (directiony > 0 and isWithinHoseRadius(0,5)):
			newVel.y = directiony * SPEED

		#player movement, checks if it can move in one direction
		velocity = newVel.normalized()*SPEED

		move_and_slide()

func disableWater() -> void:
	shootingWater = false
	$RayCast2D.enabled = false

func _shootWater() -> void:
	if(Input.is_action_just_pressed("shootWater") && connectedToSource):
		shootingWater = true
		$RayCast2D.enabled = true
	if(Input.is_action_just_released("shootWater")):
		disableWater()
	
	if ($RayCast2D.enabled):
		$RayCast2D.clear_exceptions()
		while $RayCast2D.is_colliding():
			var obj = $RayCast2D.get_collider()
			if ("name" in obj && obj.name.left(4) == "Fire"):
				obj.health -= 2
				obj.scale.x *= 0.995
				obj.scale.y *= 0.995
			$RayCast2D.add_exception( obj )
			$RayCast2D.force_raycast_update()
		


func _disconnectSource() -> void:
	if(
		Input.is_action_just_released("interact") && connectedToSource &&
		canPlaceSource):
			connectedToSource = false
			disableWater()
	# Just so we can debug with multiple sources
	elif(Input.is_action_just_released("interact") && !connectedToSource && canPlaceSource):
		hoseCenter = nextWaterSource
		connectedToSource = true
			
func _on_body_entered():
	pass
	
#this handles pushback now
func handleDamageTaken(damageAmount,vectorTo) -> void:
	if (!hasIframes):
		player.global_position.x -= vectorTo.x*0.5
		player.global_position.y -= vectorTo.y*0.5
		#hasIframes = true
		#health -= damageAmount
		#if(health<=0):
			#print("I'm dead")
		# if knockback is too far disconnect hose
		if(!isWithinHoseRadius(player.global_position.x,player.global_position.y)):
			connectedToSource = false
			disableWater()
			
		await get_tree().create_timer(2).timeout
		#hasIframes = false

func stopMoving():
	canMove = false

func _physics_process(delta: float) -> void:
	_playerMovement()
	_shootWater()
	_disconnectSource()
	queue_redraw()
	#print(firstPos)
	#print(player.global_position)


func _on_timer_timeout() -> void:
	get_parent().get_parent().reload()
