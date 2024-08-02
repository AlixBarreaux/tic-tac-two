extends Node
class_name PlayerAI


@onready var board: Board = %Board

var player_id: int = 2


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
	
	print("Board assigned cell! Global id: ", Global.current_player_id, " VS player_id: ", player_id)
	
	self.check_if_its_turn_to_play()


var is_game_over = false


func on_new_game_started() -> void:
	print(self.name, ": Game restarted, reset game over to false!")
	is_game_over = false
	
	print("Game started! Global id: ", Global.current_player_id, " VS player_id: ", player_id)
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
	print(self.name, ": CLICK!")
	board.click_button_cell(idx)


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


func counter_opponent_alignment() -> void:
	pass


func form_two_cells_alignment() -> void:
	pass


func play_turn() -> void:
	print(self.name, ": Play turn!")
	self.pick_random_cell()
	
	#if Global.turn_counter == 1:
		#self.pick_random_cell()
	#elif Global.turn_counter == 2:
		#pass
	
	# TODO: SHARE CODE BETWEEN PlayerAI and Board!
	# Detect opponent's alignment
	#for alignment_array in BoardUtils.get_winning_cell_lines():
		#
