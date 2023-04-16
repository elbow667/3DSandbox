extends Node

var tps = preload("res://Characters/player_2.tscn")

@onready var player_spawn_point: Vector3 = $SpawnPoint.global_position
@onready var player_spawn_rotation: Vector3 = $SpawnPoint.get_rotation()


# Called when the node enters the scene tree for the first time.
func _ready():
	var player = tps.instantiate()
	add_child(player)
	player.position = player_spawn_point
	player.rotation = player_spawn_rotation
	$SpawnPoint/MeshInstance3D.visible = false

