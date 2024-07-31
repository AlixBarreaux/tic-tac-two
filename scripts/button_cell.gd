extends Button
class_name ButtonCell


## Cell location
@export var cell_id: int = 0
## Who owns this cell
@export var cell_owner: EnumCellOwners.CellOwners = EnumCellOwners.CellOwners.NEUTRAL

@onready var game_node: Game = get_tree().get_root().get_node("Game")


func _on_pressed() -> void:
	cell_owner = game_node.current_player_id

	match cell_owner:
		EnumCellOwners.CellOwners.NEUTRAL:
			self.set_text("")
		EnumCellOwners.CellOwners.PLAYER_1:
			self.set_text("O")
		EnumCellOwners.CellOwners.PLAYER_2:
			self.set_text("X")
	
	Events.player_picked_cell.emit(cell_id)


func on_game_reset() -> void:
	self.set_text("")


func _ready() -> void:
	Events.game_reset.connect(on_game_reset)
