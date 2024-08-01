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
	
	Events.player_picked_cell.emit(cell_id)


func on_game_reset() -> void:
	self.set_text("")


func _ready() -> void:
	Events.game_reset.connect(on_game_reset)
