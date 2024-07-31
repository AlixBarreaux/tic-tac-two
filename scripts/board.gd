extends GridContainer
class_name Board


@export var cells: PackedInt32Array = []

## All possible combinations to win, used to determine which player won.
## Each array represents a line which contains indexes to use in cells var.
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


## List of all cells set to neutral
var initial_cells: PackedInt32Array = []

func reset() -> void:
	for button_cell: ButtonCell in self.get_children():
		cells = initial_cells


func check_if_a_player_won() -> void:
	for alignment_array in WINNING_CELLS_LINES:
		print(alignment_array)
		
		
		var next_cell_owner: int = 0
		var previous_cell_owner: int = 0
		var first_iteration: bool = true
		
		for cell_index in alignment_array:
			#print("cell_index: ", cell_index)
			next_cell_owner = cells[cell_index]
			
			print("Next cell owner: ", next_cell_owner)
			if first_iteration:
				print("First iteration, continue...")
				first_iteration = false
				previous_cell_owner = cells[cell_index]
				continue
			
			
			print("previous_cell_owner:", previous_cell_owner)
			#var next_cell_owner: int = cells[cell_index]
			if previous_cell_owner != next_cell_owner:
				print("No alignment!")
			else:
				if previous_cell_owner == EnumCellOwners.CellOwners.NEUTRAL:
					print("Blank Alignment!\n\n")
				else:
					print("Correct Alignment!\n\n")
					if previous_cell_owner == EnumCellOwners.CellOwners.PLAYER_1:
						print("Player 1 wins!")
					else:
						print("Player 2 wins!")
					return


func _ready() -> void:
	# Build cell array for the first time
	for button_cell: ButtonCell in self.get_children():
		initial_cells.push_back(button_cell.cell_owner)
	
	reset()
	
	check_if_a_player_won()
