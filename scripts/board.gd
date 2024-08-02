extends GridContainer
class_name Board

## Type not PackedInt32Array, caused problems
@export var cells: Array = []

## List of all cells set to neutral on ready
## Type: PackedInt32Array not working with duplicate()
var initial_cells: Array = []


func set_cell(cell_id: int, current_player_id: EnumCellOwners.CellOwners) -> void:
	cells[cell_id] = Global.current_player_id


func set_all_cells_to_neutral() -> void:
	cells = initial_cells.duplicate(true)
	
	for button_cell: ButtonCell in self.get_children():
		button_cell.cell_owner = EnumCellOwners.CellOwners.NEUTRAL


func click_button_cell(idx: int) -> void:
	self.get_child(idx).click()


@export var btn_cell_neutral_cell_color: Color = Color(255.0, 255.0, 255.0, 255.0)
@export var btn_cell_player_1_pawn_color: Color = Color(255.0, 255.0, 255.0, 255.0)
@export var btn_cell_player_2_pawn_color: Color = Color(255.0, 255.0, 255.0, 255.0)


func build_initial_cells() -> void:
	var button_index: int = 0
	
	for button_cell: ButtonCell in self.get_children():
		# Build cell array for the first time
		initial_cells.push_back(button_cell.cell_owner)
		# Build buttons cell ids
		button_cell.cell_id = button_index
		button_index += 1
		
		button_cell.neutral_cell_color = btn_cell_neutral_cell_color
		button_cell.player_1_pawn_color = btn_cell_player_1_pawn_color
		button_cell.player_2_pawn_color = btn_cell_player_2_pawn_color
		
	cells = initial_cells.duplicate(true)


func check_if_game_is_over() -> void:
	for alignment_array in BoardUtils.get_winning_cell_lines():
		var next_cell_owner: int = 0
		var previous_cell_owner: int = 0
		
		var iterations_count: int = 0
		var max_iterations_count: int = 3
		
		for cell_index in alignment_array:
			if iterations_count == max_iterations_count:
				iterations_count = 0
			iterations_count += 1
			
			next_cell_owner = cells[cell_index]
			
			if iterations_count == 1:
				## 1st iteration, continue...
				previous_cell_owner = cells[cell_index]
				continue
			elif iterations_count == 2:
				## 2nd iteration
				if previous_cell_owner == next_cell_owner:
					if previous_cell_owner == 0:
						## 1st and 2nd cells are neutral
						break
					## 1st and 2nd cells match
				else:
					## 1st and 2nd cells mismatch
					break
			elif iterations_count == 3:
				## 3rd iteration
				if previous_cell_owner == next_cell_owner:
					if previous_cell_owner == 0:
						## 2nd and 3rd cells are neutral
						break
					## 2nd and 3rd cells match
					print("Player ", previous_cell_owner, " wiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiins!")
					Events.game_over.emit(previous_cell_owner)
					return
				else:
					## 2nd and 3rd cells mismatch
					break
	## Check for tie match
	if not EnumCellOwners.CellOwners.NEUTRAL in cells:
		Events.game_over.emit(0)
		print("Tiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiie!")


func on_new_game_started() -> void:
	self.set_all_cells_to_neutral()


func on_player_picked_cell(cell_id: int) -> void:
	set_cell(cell_id, Global.current_player_id)
	
	check_if_game_is_over()
	Events.board_assigned_cell.emit()


func _ready() -> void:
	build_initial_cells()
	Events.new_game_started.connect(on_new_game_started)
	Events.player_picked_cell.connect(on_player_picked_cell)
	
	Events.new_game_started.emit()
