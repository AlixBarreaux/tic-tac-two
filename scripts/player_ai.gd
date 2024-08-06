extends Node
class_name PlayerAI


## Plays against the player with not necessarily optimal decisions.
### It directly clicks on a ButtonCell in the UI
### just like the player except it can bypass the "disabled mode" of the UI.

@onready var board: Board = %Board

var player_id: int = 2
var opponent_player_id: int = 1

var is_game_over = false


func check_if_its_turn_to_play() -> void:
	if is_game_over:
		print(self.name, ": Game over, I can't play!")
		return
	
	if Global.current_player_id == self.player_id:
		play_turn()


func on_board_assigned_cell() -> void:
	# If Game mode singleplayer, AI won't do anything.
	if Global.game_mode == EnumGameModes.GameModes.Multiplayer:
		return
	self.check_if_its_turn_to_play()


func on_new_game_started() -> void:
	is_game_over = false
	self.check_if_its_turn_to_play()


func on_game_over(player_id: int) -> void:
	is_game_over = true


func _ready() -> void:
	await board.ready
	randomize()
	
	if Global.game_mode == EnumGameModes.GameModes.Multiplayer:
		return
	self.check_if_its_turn_to_play()
	
	Events.new_game_started.connect(on_new_game_started)
	Events.board_assigned_cell.connect(on_board_assigned_cell)
	Events.game_over.connect(on_game_over)


func pick_cell(idx: int) -> void:
	board.click_button_cell(idx)
	did_play_turn = true


func pick_random_cell() -> void:
	var random_cell_index: int = randi_range(0, board.cells.size() - 1)
	
	for cell in board.cells:
		if board.cells[random_cell_index] != EnumCellOwners.CellOwners.NEUTRAL:
			if random_cell_index == board.cells.size() - 1:
				random_cell_index = 0
			else:
				random_cell_index += 1
			continue
		pick_cell(random_cell_index)
		break


# If 2 owned cells detected, align a 3rd to win or counter
func win_or_counter(counter_mode: bool) -> void:
	var opposing_cell_id: int = 1
	if counter_mode:
		opposing_cell_id = 2
	
	var board_line_to_check: Array = []
	
	for winning_line_array in BoardUtils.get_winning_cell_lines():
		board_line_to_check = []
		var iterations_count: int = 0
		
		for winning_cell_index in winning_line_array:
			if iterations_count >= 3:
				iterations_count = 0
				board_line_to_check.clear()
			iterations_count += 1
			board_line_to_check.append(board.cells[winning_cell_index])
		
		if not (opposing_cell_id in board_line_to_check or board_line_to_check.count(EnumCellOwners.CellOwners.NEUTRAL) > 1):
			var idx: int = 0
			for value in board_line_to_check:
				idx += 1
				if value == EnumCellOwners.CellOwners.NEUTRAL:
					pick_cell(winning_line_array[idx - 1])
					return


var did_play_turn: bool = false

func play_turn() -> void:
	did_play_turn = false
	# Not the first turn
	if Global.turn_counter != 1:
		print("Attempt to win")
		win_or_counter(false)
		if did_play_turn: return
		print("Attempt to counter")
		win_or_counter(true)
		if did_play_turn: return
		print("Attempts to win or counter failed. Picking a rand cell.")
		pick_random_cell()
		# TODO: Attempt to form an alignment of 2!
	else:
		print("First turn! Pick a random cell")
		self.pick_random_cell()

# TODO: SHARE CODE BETWEEN PlayerAI and Board!
