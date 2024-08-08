extends MarginContainer
class_name AISpeechMenuUI


@onready var regular_message_label: Label = $VBoxContainer/RegularMessageLabel
@onready var additional_message_label: Label = $VBoxContainer/AdditionalMessageLabel


func set_regular_message_label_text(message: StringName) -> void:
	self.regular_message_label.set_text(message)


func set_additional_message_label_text(message: StringName) -> void:
	self.additional_message_label.set_text(message)


func _ready() -> void:
	if Global.game_mode == EnumGameModes.GameModes.Multiplayer:
		# Hide to prevent a very brief "flash" appearance
		self.hide()
		self.queue_free()
