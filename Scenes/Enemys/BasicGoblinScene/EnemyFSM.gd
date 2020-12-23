extends "res://Scenes/Person/PlayerFSM/StateMachine/StateMachine.gd"
var noticed = false

func _ready():
	_init_states()
	call_deferred("_set_state", states.idle)


func _init_states():
	_add_state("idle")
	_add_state("walk")

func _state_logic(delta):
	if noticed:
		if !parent._notice():
			parent._searching(delta)
	

func _get_transition(delta):
	match state:
		states.idle:
			if !parent._notice():
				print(1)
				return states.walk
		states.walk:
			if parent._notice():
				print(2)
				return states.idle
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			pass
		states.walk:
			pass

func _exit_state(old_state, new_state):
	match old_state:
		states.idle:
			pass
		states.walk:
			pass
