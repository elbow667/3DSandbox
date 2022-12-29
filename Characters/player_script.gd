extends CharacterBody3D

@export var JUMP_VELOCITY = 6.5
@export var SPEED = 10.0
@export var LERP_VAL = .15
var flying = false

@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

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
		flying = true
		velocity.y = lerp(velocity.y, SPEED, LERP_VAL)
	else: # stop climbing if released key
		velocity.y = lerp(velocity.y, 0.0, LERP_VAL)
	if Input.is_action_just_pressed("fly_toggle"):
		flying = not flying
		
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
