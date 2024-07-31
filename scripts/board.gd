extends GridContainer
class_name Board


@export var cells: PackedInt32Array = []

## List of all cells set to neutral
var initial_cells: PackedInt32Array = []

func reset() -> void:
	for button_cell: ButtonCell in self.get_children():
		cells = initial_cells
	Events.game_reset.emit()


## All possible combinations to win, used to determine which player won.
## Each array represents a line which contains indexes to use in the var cells.
const WINNING_CELLS_LINES: Array = [
	[0, 1, 2],
	[3, 4, 5],
	[6, 7, 8],
	[0, 3, 6],
	[1, 4, 7],
	[2, 5, 8],
	[0, 4, 8],
	[2, 4, 6]
  ]


func check_if_a_player_won() -> void:
	for alignment_array in WINNING_CELLS_LINES:
		print("alignment_array: ", alignment_array)
		
		var next_cell_owner: int = 0
		var previous_cell_owner: int = 0
		
		var iterations_count: int = 0
		var max_iterations_count: int = 3
		
		for cell_index in alignment_array:
			if iterations_count == max_iterations_count:
				iterations_count = 0
			iterations_count += 1
			
			next_cell_owner = cells[cell_index]
			#print("next_cell_owner: ", next_cell_owner)
			
			if iterations_count == 1:
				print("First iteration, continue...")
				previous_cell_owner = cells[cell_index]
				continue
			elif iterations_count == 2:
				print("Second iteration")
				if previous_cell_owner == next_cell_owner:
					if previous_cell_owner == 0:
						## 1st and 2nd cells are neutral
						print("1st and 2nd cells are neutral! ", previous_cell_owner, " ", next_cell_owner)
						break
					print("1st and 2nd cells match! ", previous_cell_owner, " ", next_cell_owner)
				else:
					print("1st and 2nd cells mismatch!", previous_cell_owner, " ", next_cell_owner)
					break
			elif iterations_count == 3:
				print("3rd iteration")
				if previous_cell_owner == next_cell_owner:
					if previous_cell_owner == 0:
						print("2nd and 3rd cells are neutral! ", previous_cell_owner, " ", next_cell_owner)
						break
					print("2nd and 3rd cells match!", previous_cell_owner, " ", next_cell_owner)
					print("Player ", previous_cell_owner, " wiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiins!")
					Events.player_won.emit(previous_cell_owner)
					return
				else:
					print("2nd and 3rd cells mismatch!", previous_cell_owner, " ", next_cell_owner)
					break


@onready var game_node: Game = get_tree().get_root().get_node("Game")

func on_player_picked_cell(cell_id: int) -> void:
	#print("Picked cell: ", cell_id)# INDEX ON cell ARRAY!
	#print("Game node - current_player_id: ", game_node.current_player_id)
	cells[cell_id] = game_node.current_player_id
	check_if_a_player_won()


func _ready() -> void:
	var button_index: int = 0
	
	for button_cell: ButtonCell in self.get_children():
		# Build cell array for the first time
		initial_cells.push_back(button_cell.cell_owner)
		# Build buttons cell ids
		button_cell.cell_id = button_index
		button_index += 1
	
	Events.player_picked_cell.connect(on_player_picked_cell)
	
	reset()
