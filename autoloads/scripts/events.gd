extends Node
#class_name Events


signal new_game_started
signal player_picked_cell(id: int)
# Makes sure the id has been assigned. Use this instead of player_picked_cell
signal turn_data_updated
signal board_assigned_cell
# Player id determining who won
signal game_over(id: int)
