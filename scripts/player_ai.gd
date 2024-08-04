extends Node
class_name PlayerAI

### It directly clicks on a ButtonCell in the UI
### just like the player except it can bypass the "disabled" mode of the UI.

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
	#print("Board assigned cell! Global id: ", Global.current_player_id, " VS player_id: ", player_id)
	self.check_if_its_turn_to_play()


func on_new_game_started() -> void:
	#print(self.name, ": Game restarted, reset game over to false!")
	is_game_over = false
	#print("Game started! Global id: ", Global.current_player_id, " VS player_id: ", player_id)
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
	#print(self.name, ": CLICK!")
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


func complete_three_cells_alignment() -> void:
	pass


func play_turn() -> void:
	if Global.turn_counter == 1:
		print("First turn! Pick a random cell")
		self.pick_random_cell()
	else:
		# Can I win the next turn?
		print(board.cells)
		
		var board_line_to_check: Array = []
		
		
		for winning_line_array in BoardUtils.get_winning_cell_lines():
			#print(line_to_check, " VS ", winning_line_array)
			
			print("\nWinning array: ", winning_line_array)
			
			for winning_cell_index in winning_line_array:
				board_line_to_check.append(board.cells[winning_cell_index])
			
			print("Constructed array: ", board_line_to_check)
			
			
			var iterations_count: int = 0
			var neutral_cell_index: int = 2
			var neutral_cell_detected: bool = false
			var owned_cell_detected: bool = false
			
			for cell_to_check in board_line_to_check:
				iterations_count += 1
				print("Iterations count: ", iterations_count)
				
				print("board.cells[] index: ", cell_to_check, " - and value: ", cell_to_check)
				
				if cell_to_check == opponent_player_id:
					print("Opponent already has a cell: ", cell_to_check)
					break
				
				elif cell_to_check == EnumCellOwners.CellOwners.NEUTRAL:
					if neutral_cell_detected:
						print("2 neutral cells were detected! Cell: ", cell_to_check)
						break
					neutral_cell_index = iterations_count - 1
					neutral_cell_detected = true
					continue
				else:
					if not owned_cell_detected:
						print("One owned cell detected!")
						owned_cell_detected = true
						continue
					print("2 owned cells detected!")
					
					print("+++++++++++++++ I have an alignment of 2!")
					print("+++ Combination: ", winning_line_array)
					print("+++ Owned cells in this combination: ", board_line_to_check)
					print("+++ I must take the neutral cell: ", neutral_cell_index)
					
					print("+++ The neutral cell in the combination is 0: ", board_line_to_check[neutral_cell_index])
					print("+++ The neutral cell index in the combination is: ", winning_line_array[neutral_cell_index])
					
					var final_board_index: int = winning_line_array[neutral_cell_index]
					print("+++ Index to use in board.cells: ", final_board_index)
					
					print("+++ Taking neutral cell in board at index: ", board.cells[final_board_index])
					pick_cell(final_board_index)
					return
				
			print("Can't find 2 of my cells cells aligned in this line.")
			
			board_line_to_check = []
		print("I can't find any way to win.")
		pick_random_cell()

## TODO: REUSE THIS 2 ALIGNMENT CHECK TO USE FOR BOTH WINNING AND COUNTERING


# Should I counter my opponent?
# Align
	
	
	# TODO: SHARE CODE BETWEEN PlayerAI and Board!
	# Detect opponent's alignment
	#for alignment_array in BoardUtils.get_winning_cell_lines():
		#
