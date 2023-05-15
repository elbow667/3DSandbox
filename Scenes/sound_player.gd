extends Node

const SHOT = preload("res://Sounds/pistol.ogg")

# sound_player.tscn needs to be an autoload for this to work

@onready var audioPlayers: = $AudioPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
			
