extends RefCounted
class_name BoardUtils


## Returns all possible combinations to win, used to determine which player won.
## Each array represents a line which contains indexes to use in the var cells.
static func get_winning_cells_line() -> Array:
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
	
	return WINNING_CELLS_LINES
