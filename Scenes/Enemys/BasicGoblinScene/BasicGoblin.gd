extends KinematicBody2D

var hp = 100
var speed = 65
var path = []
onready var navigation = $"../../Navigation2D"
var dir = -1
var prev_dir

func _searching(delta):
	var posPlayer = $"../../../Person".position
	if path.size() == 0:
			path = navigation.path_to_player(self.position)
	else:
		self.position += (path[0] - self.position).normalized()*speed*delta
		prev_dir = dir
		dir = sign((path[0] - self.position).x)
		if dir == 0:
			dir = 1
		if dir != prev_dir:
			$Body.scale.x = dir
		$Anim.play("walk")
		if self.position.distance_to(path[0]) < speed*delta:
			path.remove(0)

func _notice():
	var posPlayer = $"../../../Person"
	var space_state = get_world_2d().direct_space_state
	var res = space_state.intersect_ray(self.position, posPlayer.position,\
		[self,posPlayer,$AreaZone/ControlZone])
	return res


func _on_ControlZone_body_entered(body):
	if body.is_in_group("player"):
		$EnemyFSM.noticed = true


func _on_ControlZone_body_exited(body):
	if body.is_in_group("player"):
		$EnemyFSM.noticed = false
		$Anim.play("idle")


func _on_UpdatePathTimer_timeout():
	path = navigation.path_to_player(self.position)
