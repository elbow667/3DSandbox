extends RigidBody3D

var shoot = false

@export var DAMAGE = 50
@export var SPEED = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shoot:
		print_debug(transform.basis.z)
		apply_impulse(-transform.basis.z, transform.basis.z * SPEED * delta)

func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		queue_free()
	else:
		queue_free()


func _on_timer_timeout():
	queue_free()
