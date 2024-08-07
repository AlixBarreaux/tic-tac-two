extends ButtonWithSounds
class_name NewGameButton


func _on_pressed() -> void:
	super()
	Events.new_game_started.emit()


func on_new_game_started() -> void:
	self.hide()


func on_game_over(_player_id: int) -> void:
	self.show()


func _ready() -> void:
	Events.new_game_started.connect(on_new_game_started)
	Events.game_over.connect(on_game_over)
