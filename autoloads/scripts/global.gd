extends Node
#class_name Global


enum PlayerTypes { HUMAN, AI }

@export var player_1_type: PlayerTypes = PlayerTypes.HUMAN
@export var player_2_type: PlayerTypes = PlayerTypes.AI

## Player who is the first to play a move
@export var starting_player: int = randi_range(1, 2)
## ID of the player currently playing
@onready var current_player_id: int = starting_player


@export var game_mode: EnumGameModes.GameModes = EnumGameModes.GameModes.Singleplayer

func set_game_mode(value: EnumGameModes.GameModes) -> void:
	game_mode = value
	
	#match value:
		#EnumGameModes.GameModes.Singleplayer:
			#pass
		#EnumGameModes.GameModes.Multiplayer:
			#pass
		#_:
			#printerr("(!) ERROR in: " + self.get_name() + ": Unrecognized enum value!")


func on_player_picked_cell(_player_id: int) -> void:
	await Events.board_assigned_cell
	if current_player_id == 1:
		current_player_id = 2
	else: current_player_id = 1


func _ready() -> void:
	randomize()
	Events.player_picked_cell.connect(on_player_picked_cell)
	
	if starting_player == 1:
		current_player_id = 1
	else:
		current_player_id = 2
	
	print("Player ", current_player_id , " got the first move!")
