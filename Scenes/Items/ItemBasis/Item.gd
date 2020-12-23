extends Node2D
onready var recovery_timer = $RecoveryTimer

func use(user):
	if recovery_timer.is_stopped():
		recovery_timer.start()
		$ItemSwinger.use(user)
		$AnimFX.play("slash")

func _on_Person_flipped(direction):
	$ItemSwinger.on_flip(direction)
