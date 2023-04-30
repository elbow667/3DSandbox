extends CharacterBody3D

@export var max_speed = 10
@export var acceleration = 70
@export var friction = 60
@export var air_friction = 10
@export var gravity = -40
@export var jump_impulse : float = 20
@export var mouse_sensitivity = 0.1
@export var controller_sensitivity = 3
@export var rot_speed = 25

var snap_vector : = Vector3.ZERO
@onready var spring_arm : = $SpringArm3D
@onready var pivot : = $Pivot
@onready var bullet: = preload("res://bullet.tscn")
@onready var muzzle: = $Pivot/Gun/Muzzle
@onready var aimcast: = $Pivot/Gun/Muzzle/AimCast

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func shoot_gun():
		if Input.is_action_just_pressed("click"):
			if aimcast.is_colliding():
				var b = bullet.instantiate()
				muzzle.add_child(b)
				b.look_at(aimcast.get_collision_point(), Vector3.UP)
				b.shoot = true
				
func _unhandled_input(event):
	if event.is_action_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action_pressed("toggle_mouse_captured"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		spring_arm.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-75), deg_to_rad(75))
		
func _physics_process(delta):
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(input_vector, direction, delta)
	apply_friction(direction,delta)
	apply_gravity(delta)
	jump()
	shoot_gun()
	move_and_slide()
	

		
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.z = Input.get_action_strength("back") - Input.get_action_strength("forward")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
func get_direction(input_vector):
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction

func apply_movement(input_vector, direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
#		pivot.look_at(global_transform.origin + direction, Vector3.UP)
		pivot.rotation.y = lerp_angle(pivot.rotation.y, atan2(-input_vector.x, -input_vector.z), rot_speed * delta)

func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(direction * max_speed, air_friction * delta).x
			velocity.z = velocity.move_toward(direction * max_speed, air_friction * delta).z
	
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y,gravity, jump_impulse)

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_impulse
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2
		
		


