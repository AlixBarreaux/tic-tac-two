extends Node
class_name PlayerAI


## Plays against the player with not necessarily optimal decisions.
### It directly clicks on a ButtonCell in the UI
### just like the player except it can bypass the "disabled mode" of the UI.

@onready var board: Board = %Board
@onready var ai_speech_menu_ui: AISpeechMenuUI = %AISpeechMenuUI

var regular_message_to_send: String = ""
var additional_message_to_send: String = ""

@onready var think_timer: Timer = $ThinkTimer

var player_id: int = 2
var opponent_player_id: int = 1

var is_game_over = false


func wait() -> void:
	self.think_timer.start()
	await think_timer.timeout


func check_if_its_turn_to_play() -> void:
	if is_game_over: return
	
	if Global.current_player_id == self.player_id:
		if Global.turn_counter == 1:
			ai_speech_menu_ui.set_regular_message_label_text(tr("Good to see you there general.\nTake a seat!"))
			await self.wait()
		play_turn()
	else:
		ai_speech_menu_ui.set_additional_message_label_text(tr("Waiting for opponent to play..."))


func on_board_assigned_cell() -> void:
	# If Game mode singleplayer, AI won't do anything.
	if Global.game_mode == EnumGameModes.GameModes.Multiplayer:
		return
	self.check_if_its_turn_to_play()


func on_new_game_started() -> void:
	is_game_over = false
	ai_speech_menu_ui.set_regular_message_label_text(tr("Good to see you there general.\nTake a seat!"))
	ai_speech_menu_ui.set_additional_message_label_text(tr("Game started. Nothing to do."))
	self.check_if_its_turn_to_play()


func on_game_over(received_player_id: int, _winning_cells_line: Array) -> void:
	is_game_over = true
	
	if received_player_id == 0:
		ai_speech_menu_ui.set_regular_message_label_text(tr("Tie! Ok let's do that again!"))
	elif received_player_id == 1:
		ai_speech_menu_ui.set_regular_message_label_text(tr("You won! Great job soldier!"))
	
	ai_speech_menu_ui.set_additional_message_label_text(tr("Game over. I can't play anymore."))


func _ready() -> void:
	await ai_speech_menu_ui.ready
	ai_speech_menu_ui.set_regular_message_label_text(tr("Good to see you there general.\nTake a seat!"))
	ai_speech_menu_ui.set_additional_message_label_text(tr("Game started. Nothing to do."))
	randomize()
	
	if Global.game_mode == EnumGameModes.GameModes.Multiplayer:
		return
	
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
		ai_speech_menu_ui.set_regular_message_label_text(tr("What about this?"))
		break


# If 2 owned cells detected, align a 3rd to win or counter
func win_or_counter(counter_mode: bool) -> void:
	var opposing_cell_id: int = 1
	if counter_mode:
		opposing_cell_id = 2
	
	var board_line_to_check: Array = []
	
	for winning_line_array in BoardUtils.get_winning_cells_line():
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
					if counter_mode:
						ai_speech_menu_ui.set_regular_message_label_text(tr("Certainly not!"))
						ai_speech_menu_ui.set_additional_message_label_text(tr("I countered my opponent."))
					else:
						ai_speech_menu_ui.set_regular_message_label_text(tr("I'm sorry for you but I won son.\nI'm sure you'll do better next time!"))
						ai_speech_menu_ui.set_additional_message_label_text(tr("I won."))
					pick_cell(winning_line_array[idx - 1])
					return


# Find a line with 1 owned cell randomly and align an owned cell next to 
# the other one or with a neutral cell in the middle.
func align_second_owned_cell_randomly() -> void:
	var board_line_to_check: Array = []
	var possible_combinations: Array = []
	
	for winning_line_array in BoardUtils.get_winning_cells_line():
		board_line_to_check = []
		var iterations_count: int = 0
		
		for winning_cell_index in winning_line_array:
			if iterations_count >= 3:
				iterations_count = 0
				board_line_to_check.clear()
			iterations_count += 1
			board_line_to_check.append(board.cells[winning_cell_index])
		
		if board_line_to_check.count(self.player_id) == 1 and board_line_to_check.count(EnumCellOwners.CellOwners.NEUTRAL) == 2:
			possible_combinations.append(winning_line_array)
			
	if possible_combinations:
		for combination_array in possible_combinations:
			var possible_combinations_rand_idx: int = randi_range(0, possible_combinations.size() - 1)
			combination_array = possible_combinations[possible_combinations_rand_idx]
			
			var combination_array_rand_idx: int = randi_range(0, combination_array.size() -1)
			if board.cells[combination_array[combination_array_rand_idx]] != EnumCellOwners.CellOwners.NEUTRAL:
				if combination_array_rand_idx == combination_array.size() -1:
					combination_array_rand_idx = 0
				else:
					combination_array_rand_idx += 1
			
			ai_speech_menu_ui.set_regular_message_label_text(tr("There you go!"))
			ai_speech_menu_ui.set_additional_message_label_text(tr("I placed a pawn in a line where there were 2 neutral cells."))
			pick_cell(combination_array[combination_array_rand_idx])
			return


var did_play_turn: bool = false


func play_turn() -> void:
	did_play_turn = false
	# Not the first turn
	ai_speech_menu_ui.set_regular_message_label_text(tr("Hmmmmm..."))
	ai_speech_menu_ui.set_additional_message_label_text(tr("Start playing my turn."))
	if Global.turn_counter != 1:
		await self.wait()
		ai_speech_menu_ui.set_additional_message_label_text(tr("I'm checking to see if I can win."))
		self.win_or_counter(false)
		if did_play_turn: return
		
		await self.wait()
		ai_speech_menu_ui.set_additional_message_label_text(tr("I couldn't find a way to win. I'm now trying to counter you."))
		self.win_or_counter(true)
		if did_play_turn: return
		
		await self.wait()
		ai_speech_menu_ui.set_additional_message_label_text(tr("I couldn't find a way to counter you. I'll attempt to align a second pawn with one of mine if none of your pawns is in the way."))
		self.align_second_owned_cell_randomly()
		if did_play_turn: return
		
		await self.wait()
		ai_speech_menu_ui.set_additional_message_label_text(tr("I couldn't align a pawn with one of mine without on of yours in the way. The last thing to do now is to pick a random spot."))
		self.pick_random_cell()
	else:
		await self.wait()
		ai_speech_menu_ui.set_additional_message_label_text(tr("As always I pick a random spot on the first turn."))
		self.pick_random_cell()
