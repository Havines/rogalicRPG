extends "res://Scenes/Person/PlayerFSM/StateMachine/StateMachine.gd"

func _ready():
	_init_states()
	call_deferred("_set_state", states.idle)

func _init_states():
	_add_state("idle")
	_add_state("walk")
	_add_state("combat")
	_add_state("roll")

func _state_logic(delta):
	parent._handleInput()
	parent._applyMovement(delta)
	parent._applyAnim(delta)
	parent._swinging(delta)

func _get_transition(delta):
	match state:
		states.idle:
			if parent.linear_vel.x != 0:
				return states.walk
		states.walk:
			if parent.linear_vel.x == 0:
				return states.idle
		states.combat:
			pass
		states.roll:
			pass
	return null

func _enter_state(new_state, old_state):
	match new_state:
		states.idle:
			pass
		states.walk:
			pass
		states.combat:
			pass
		states.roll:
			pass

func _exit_state(old_state, new_state):
	match old_state:
		states.idle:
			pass
		states.walk:
			pass
		states.combat:
			pass
		states.roll:
			pass
