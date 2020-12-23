extends Node2D

const RESET_DURATION = 0.15

onready var tween = $Tween
onready var telegraph_timer = $TelegraphTimer
onready var wrist = $Wrist
onready var reset_timer = $ResetTimer

export (NodePath) var remote_path setget set_remote_path
export var shoulder_angle := PI / 3.0 setget set_shoulder_angle
export var wrist_angle := PI / 3.0 setget set_wrist_angle
export var telegraph_time = 0.4
export var recovery_time = 0.4
export var wrist_offset = 8 setget set_wrist_offset

var hold_direction = -1

func _ready():
	rotation = shoulder_angle * hold_direction
	wrist.rotation = wrist_angle * hold_direction
	set_remote_path(remote_path)
	wrist.position.x = wrist_offset

func telegraph():
	tween.stop_all()
	tween.interpolate_property(self, "rotation", rotation, rotation + PI / 2.5 * hold_direction, \
		telegraph_time, Tween.TRANS_QUINT, Tween.EASE_OUT)
	tween.start()
	telegraph_timer.start(telegraph_time)

func use(user):
	hold_direction = -hold_direction
	rotation = shoulder_angle * sign(hold_direction)
	wrist.rotation = wrist_angle * sign(hold_direction)
	recover()
	reset_timer.stop()
	if sign(user.body.scale.x) == hold_direction:
		reset_timer.start()

func recover():
	tween.stop_all()
	tween.interpolate_property(self, "rotation", rotation, rotation + PI / 2.0 * hold_direction, \
		recovery_time / 2.0, Tween.TRANS_SINE, Tween.EASE_OUT)
	tween.interpolate_property(self, "rotation", rotation + PI / 2.0 * hold_direction, rotation, \
		recovery_time / 2.0, Tween.TRANS_SINE, Tween.EASE_OUT, recovery_time / 2.0)
	tween.start()

func set_remote_path(value: NodePath):
	remote_path = value
	var node = get_node_or_null(value)
	if node != null:
		wrist.remote_path = wrist.get_path_to(node)

func set_shoulder_angle(value: float):
	shoulder_angle = value
	rotation = value * hold_direction

func set_wrist_angle(value: float):
	wrist_angle = value
	wrist.rotation = value * hold_direction

func set_wrist_offset(value: float):
	wrist_offset = value
	wrist.position.x = value

func _on_ResetTimer_timeout():
	hold_direction = -hold_direction
	tween.stop_all()
	tween.interpolate_property(self, "rotation", rotation, PI / 3.0 * sign(hold_direction), \
			RESET_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(wrist, "rotation", wrist.rotation, PI / 3.0 * sign(hold_direction), \
			RESET_DURATION, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func on_flip(direction):
	reset_timer.stop()
	if hold_direction == direction:
		_on_ResetTimer_timeout()
