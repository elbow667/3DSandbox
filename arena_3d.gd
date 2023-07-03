extends Node

var tps = preload("res://Characters/player_2.tscn")

@onready var player_spawn_point: Vector3 = $SpawnPoint.global_position
@onready var player_spawn_rotation: Vector3 = $SpawnPoint.get_rotation()
@onready var player_teleport_point: Vector3 = $TeleportPoint.global_position
@onready var player_teleport_rotation: Vector3 = $TeleportPoint.get_rotation()

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_player()



# Player falls or gets thrown off the platform
func _on_area_3d_body_exited(body):
	body.position = player_spawn_point
	body.rotation = player_spawn_rotation
#	var _reload = get_tree().reload_current_scene()

func spawn_player():
	var player = tps.instantiate()
	add_child(player)
	player.position = player_spawn_point
	player.rotation = player_spawn_rotation


func _on_area_3d_2_body_entered(body):
	body.position = player_teleport_point
	body.rotation = player_teleport_rotation
