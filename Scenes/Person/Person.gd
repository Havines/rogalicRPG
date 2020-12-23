extends KinematicBody2D

signal flipped(direction)

export var WALK_SPEED = 100

onready var weapon = $Weapon
onready var body = $Body

var linear_vel = Vector2()
var target_vel = 0
var anim = ""
var new_anim = ""
var facing = 1

func _handleInput():
	var target_speed = Vector2()
	if Input.is_action_pressed("ui_down"):
		target_speed += Vector2.DOWN
	if Input.is_action_pressed("ui_left"):
		target_speed += Vector2.LEFT
	if Input.is_action_pressed("ui_right"):
		target_speed += Vector2.RIGHT
	if Input.is_action_pressed("ui_up"):
		target_speed += Vector2.UP
	if Input.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if Input.is_action_pressed("ui_accept"):
		$Weapon/Sword.use(self)
	target_vel = target_speed.normalized()

func _applyMovement(delta):
	linear_vel = move_and_slide(linear_vel)
	target_vel *= WALK_SPEED
	linear_vel = target_vel
	##ANIM ZONE
	if linear_vel != Vector2(0,0):
		new_anim = "run"
	else:
		new_anim = "idle"

func _applyAnim(delta):
	if new_anim != anim:
		anim = new_anim
		$Anim.play(anim)

func _swinging(delta):
	weapon.rotation = (get_global_mouse_position() - weapon.global_position).angle()
	var displacement = get_global_mouse_position() - global_position
	var prev_facing = facing
	facing = sign(displacement.x)
	if facing == 0:
		facing = 1
	if facing != prev_facing:
		body.scale.x = facing
		emit_signal("flipped", facing)

