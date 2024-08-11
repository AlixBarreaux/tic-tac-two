extends Line2D
class_name WinningLine2D


@onready var board: Board = %Board


func trace_colored_line_on_winning_cells(id: int, winning_cells_board_idxs: Array) -> void:
	if id == 1:
		self.set_modulate(Colors.get_player_one_color())
	elif id == 2:
		self.set_modulate(Colors.get_player_two_color())
	else:
		# Don't trace a colored line
		return
	
	var first_cell: ButtonCell = board.get_child(winning_cells_board_idxs[0])
	var last_cell: ButtonCell = board.get_child(winning_cells_board_idxs[winning_cells_board_idxs.size() - 1])
	var first_point_position: Vector2 = first_cell.get_position() + (first_cell.get_size() / 2)
	var last_point_position: Vector2 = last_cell.get_position() + (last_cell.get_size() / 2)
	
	self.set_points([first_point_position, last_point_position])


func on_new_game_started() -> void:
	self.set_points([])


func on_game_over(id: int, winning_cells_board_idxs: Array) -> void:
	self.trace_colored_line_on_winning_cells(id, winning_cells_board_idxs)


func _ready() -> void:
	Events.new_game_started.connect(on_new_game_started)
	Events.game_over.connect(on_game_over)
