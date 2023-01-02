extends CharacterBody3D

@export var SPEED := 5.0
@export var JUMP_VELOCITY := 4.5
@export var LERP_VAL := .15

@onready var flying : bool = false

@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var gravity = 9.8

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * .005)
		spring_arm.rotate_x(-event.relative.y * .005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor() and !flying:
		velocity.y -= gravity * delta

# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
# Handle Fly
	
	if Input.is_action_pressed("fly"):
		velocity.y = lerp(velocity.y, SPEED, LERP_VAL)
		if not is_on_floor():
			flying = true
	elif Input.is_action_pressed("land"):
		velocity.y = lerp(velocity.y, -SPEED, LERP_VAL)
	elif velocity.y >= 0.0: # Check if velocity.y is positive
			velocity.y = lerp(velocity.y, 0.0, LERP_VAL)
	if Input.is_action_just_pressed("fly_toggle"):
		flying = not flying
	if is_on_floor() and flying:
			flying = false
			print("Just Landed")
		
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VAL)
		
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
		
		

	move_and_slide()
