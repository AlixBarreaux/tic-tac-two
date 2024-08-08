extends Node
#class_name Sound


@onready var ambient_player: AudioStreamPlayer = $AmbientPlayer
@onready var music_player: AudioStreamPlayer = $MusicPlayer


@onready var stream_players: Dictionary = {
	"ambient": ambient_player,
	"music": music_player
}


func play_sound(stream_player: AudioStreamPlayer) -> void:
	stream_player.play()


func stop_sound(stream_player: AudioStreamPlayer) -> void:
	stream_player.stop()
