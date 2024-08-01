extends CanvasLayer
class_name MainMenu


@export_file("*.scn", "*.tscn") var game_scene_file_path: String = "res://scenes/game.tscn"


func _ready() -> void:
	assert(FileAccess.file_exists(self.game_scene_file_path))


func _on_play_sp_button_pressed() -> void:
	Global.set_game_mode(EnumGameModes.GameModes.Singleplayer)
	get_tree().change_scene_to_file(self.game_scene_file_path)


func _on_play_local_mp_button_pressed() -> void:
	Global.set_game_mode(EnumGameModes.GameModes.Multiplayer)
	get_tree().change_scene_to_file(self.game_scene_file_path)
