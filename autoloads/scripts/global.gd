extends Node
#class_name Global

## Player 1 MUST be a human at all times!
@export var player_1_type: EnumPlayerTypes.PlayerTypes = EnumPlayerTypes.PlayerTypes.HUMAN
@export var player_2_type: EnumPlayerTypes.PlayerTypes = EnumPlayerTypes.PlayerTypes.HUMAN

## Player who is the first to play a move
@export var starting_player: int = randi_range(1, 2)
## ID of the player currently playing
@onready var current_player_id: int = starting_player

func set_random_starting_player() -> void:
	starting_player = randi_range(1, 2)
	current_player_id = starting_player
	print("\nPlayer ", current_player_id , " got the first move!")


var turn_counter: int = 1


@export var game_mode: EnumGameModes.GameModes = EnumGameModes.GameModes.Multiplayer

func set_game_mode(value: EnumGameModes.GameModes) -> void:
	game_mode = value
	
	match value:
		EnumGameModes.GameModes.Singleplayer:
			player_1_type = EnumPlayerTypes.PlayerTypes.HUMAN
			player_2_type = EnumPlayerTypes.PlayerTypes.AI
		EnumGameModes.GameModes.Multiplayer:
			player_1_type = EnumPlayerTypes.PlayerTypes.HUMAN
			player_2_type = EnumPlayerTypes.PlayerTypes.HUMAN
		_:
			printerr("(!) ERROR in: " + self.get_name() + ": Unrecognized enum value!")


func on_new_game_started() -> void:
	self.set_random_starting_player()
	turn_counter = 1


func update_turn_data() -> void:
	if current_player_id == 1:
		current_player_id = 2
	else: current_player_id = 1
	
	turn_counter += 1
	Events.turn_data_updated.emit()


func on_board_assigned_cell() -> void:
	update_turn_data()


func _ready() -> void:
	randomize()
	Events.new_game_started.connect(on_new_game_started)
	Events.board_assigned_cell.connect(on_board_assigned_cell)
