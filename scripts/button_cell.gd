extends ButtonWithSounds
class_name ButtonCell


@export var neutral_cell_color: Color = Color(1.0, 1.0, 1.0, 0.0)
var player_1_pawn_color: Color = Colors.get_player_one_color()
var player_2_pawn_color: Color = Colors.get_player_two_color()


@onready var texture_rect: TextureRect = $Control/TextureRect

func set_cell_visuals(color: Color) -> void:
	self.texture_rect.set_modulate(color)
	self.texture_rect.show()


func pick_cell_visuals_based_on_owner() -> void:
	match cell_owner:
		EnumCellOwners.CellOwners.NEUTRAL:
			set_cell_visuals(neutral_cell_color)
		EnumCellOwners.CellOwners.PLAYER_1:
			set_cell_visuals(player_1_pawn_color)
		EnumCellOwners.CellOwners.PLAYER_2:
			set_cell_visuals(player_2_pawn_color)


## Cell location
var cell_idx: int = 0
## Who owns this cell
@export var cell_owner: EnumCellOwners.CellOwners = EnumCellOwners.CellOwners.NEUTRAL


func enable() -> void:
	self.set_mouse_filter(MOUSE_FILTER_STOP)


func disable() -> void:
	self.set_mouse_filter(MOUSE_FILTER_IGNORE)
	self.release_focus()

func click() -> void:
	self._on_pressed()


const DENY_SOUND_FILE_PATH: StringName = "res://assets/sound/sound-effects/button_deny.wav"

func _on_pressed() -> void:
	if self.cell_owner != EnumCellOwners.CellOwners.NEUTRAL:
		$AudioStreamPlayer.set_stream(load(DENY_SOUND_FILE_PATH))
		$AudioStreamPlayer.play()
		return
	super()
	cell_owner = Global.current_player_id
	self.pick_cell_visuals_based_on_owner()
	self.disable()
	Events.player_picked_cell.emit(cell_idx)


func on_new_game_started() -> void:
	set_cell_visuals(neutral_cell_color)
	is_game_over = false
	
	if Global.current_player_id == 1:
		self.enable()
	else:
		self.disable()


var is_game_over: bool = false

func on_game_over(_id: int, winning_cells_line: Array) -> void:
	self.disable()
	is_game_over = true
	
	# Higlight if is winning cell
	if not self.cell_idx in winning_cells_line:
		if self.cell_owner == EnumCellOwners.CellOwners.NEUTRAL:
			return
		self.texture_rect.modulate.a = 0.5


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
