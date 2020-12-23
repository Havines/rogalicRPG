extends Navigation2D
onready var pos_player = $"../../Person"

func _ready():
	pass


func path_to_player(cord):
	var point = get_simple_path(cord, pos_player.position, true)
	return point
