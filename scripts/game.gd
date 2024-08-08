extends Node
class_name Game


func _ready() -> void:
	AudioManager.stop_sound(AudioManager.stream_players.music)
	AudioManager.play_sound(AudioManager.stream_players.ambient)
