extends RigidBody3D

var shoot = false

@export var DAMAGE: int = 50
@export var SPEED: int = 70
var bodies_to_exclude = []
var bullet_last_pos := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if shoot:
		translate(Vector3(0,-0.01,-1 * SPEED) * delta)
#		apply_impulse(-transform.basis.z, transform.basis.z * SPEED * delta)


	
	
func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= DAMAGE
		queue_free()
	else:
		queue_free()


func _on_timer_timeout():
	queue_free()
