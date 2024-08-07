extends Button
class_name ButtonCell


var neutral_cell_color: Color = Color(255.0, 255.0, 255.0, 255.0)
var player_1_pawn_color: Color = Color(255.0, 255.0, 255.0, 255.0)
var player_2_pawn_color: Color = Color(255.0, 255.0, 255.0, 255.0)

func set_color(color: Color) -> void:
	set("theme_override_colors/font_color", color)


## Cell location
var cell_id: int = 0
## Who owns this cell
@export var cell_owner: EnumCellOwners.CellOwners = EnumCellOwners.CellOwners.NEUTRAL


func enable() -> void:
	self.set_mouse_filter(MOUSE_FILTER_STOP)


func disable() -> void:
	self.set_mouse_filter(MOUSE_FILTER_IGNORE)


func click() -> void:
	_on_pressed()


func _on_pressed() -> void:
	cell_owner = Global.current_player_id

	match cell_owner:
		EnumCellOwners.CellOwners.NEUTRAL:
			self.set_text("")
			set_color(neutral_cell_color)
		EnumCellOwners.CellOwners.PLAYER_1:
			self.set_text("O")
			set_color(player_1_pawn_color)
		EnumCellOwners.CellOwners.PLAYER_2:
			self.set_text("X")
			set_color(player_2_pawn_color)
	
	disable()
	Events.player_picked_cell.emit(cell_id)


func on_new_game_started() -> void:
	self.set_text("")
	is_game_over = false
	self.enable()


var is_game_over: bool = false

func on_game_over(id: int) -> void:
	self.disable()
	is_game_over = true


func on_turn_data_updated() -> void:
	if is_game_over:
		disable()
		return
	
	if Global.current_player_id == 1:
		if Global.player_1_type == EnumPlayerTypes.PlayerTypes.HUMAN:
			if cell_owner == EnumCellOwners.CellOwners.NEUTRAL:
				self.enable()
		else:
			self.disable()
	if Global.current_player_id == 2:
		if Global.player_2_type == EnumPlayerTypes.PlayerTypes.HUMAN:
			if cell_owner == EnumCellOwners.CellOwners.NEUTRAL:
				self.enable()
		else:
			self.disable()


func _ready() -> void:
	Events.new_game_started.connect(on_new_game_started)
	Events.game_over.connect(on_game_over)
	Events.turn_data_updated.connect(on_turn_data_updated)
