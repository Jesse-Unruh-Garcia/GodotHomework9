extends CharacterBody2D
var gravity : Vector2
@export var jump_height : float ## How high should they jump?
@export var movement_speed : float ## How fast can they move?
@export var horizontal_air_coefficient : float ## Should the player move more slowly left and right in the air? Set to zero for no movement, 1 for the same
@export var speed_limit : float ## What is the player's max speed? 
@export var friction : float ## What friction should they experience on the ground?

# Called when the node enters the scene tree for the first time.
func _ready():
	#Sets the gravity of the character, essentially determining how high they can jump vertically
	gravity = Vector2(0, 100)
	pass # Replace with function body.


func _get_input():
	if is_on_floor():
		#When the button for moving left is pressed, changes the characters
		#velocity in order to move them in the left direction
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed,0)

		#When the button for moving right is pressed, changes the characters
		#velocity in order to move them in the right direction
		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed,0)

		#When the button for jumping is pressed, changes the characters
		#velocity in order to lift them vertically up
		if Input.is_action_just_pressed("jump"): # Jump only happens when we're on the floor (unless we want a double jump, but we won't use that here)
			velocity += Vector2(1,-jump_height)

	#This section essentially does the same as the above section, however
	#this is for when the character is in the air, which will have different
	#movement then when stationary on the ground
	#For both, the velocity has to taken into account the vertical movement
	#and thus changes the vector of velocity accordingly
	if not is_on_floor():
		if Input.is_action_pressed("move_left"):
			velocity += Vector2(-movement_speed * horizontal_air_coefficient,0)

		if Input.is_action_pressed("move_right"):
			velocity += Vector2(movement_speed * horizontal_air_coefficient,0)

#We don't want our character moving too fast, so we set limits to their velocity
func _limit_speed():
	#If the object is moving too fast in the right direction, we limit it
	if velocity.x > speed_limit:
		velocity = Vector2(speed_limit, velocity.y)

	#If the object is moving too fast in the left direction, we limit it
	if velocity.x < -speed_limit:
		velocity = Vector2(-speed_limit, velocity.y)

#Friction forces need to be aplied
func _apply_friction():
	#This ensures friction is only applied when the character is on the ground and stationary
	if is_on_floor() and not (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		#Character will begin to naturally move down according to how steep the angle is
		velocity -= Vector2(velocity.x * friction, 0)
		if abs(velocity.x) < 5:
			velocity = Vector2(0, velocity.y) # if the velocity in x gets close enough to zero, we set it to zero

#This applies gravity whenever the character is not on the ground
func _apply_gravity():
	if not is_on_floor():
		velocity += gravity

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#This section just ensures that all the above functions are applied at all times
	_get_input()
	_limit_speed()
	_apply_friction()
	_apply_gravity()

	move_and_slide()
	pass
