extends CharacterBody2D

class_name Player

@export var move_speed: float = 250.0
@export var gravity_speed: float = 300.0
@export var jump_speed: float = 750.0

const JUMP_UP_FRAMES: int = 10
const JUMP_HANG_FRAMES: int = 10

var start_pos: Vector2 = Vector2.ZERO
var is_grounded: bool = false
var jump_frame: int = 0

func _ready() -> void:
	start_pos = self.global_position
	init_grounded_signals()

func init_grounded_signals() -> void:
	var area := $FeetArea as Area2D
	area.connect("area_entered", area_entered)
	area.connect("area_exited", area_exited)
	
func area_entered(area: Area2D) -> void:
	if area.is_in_group("player") || \
		area.is_in_group("primary_portal") || area.is_in_group("secondary_portal"):
		return
	is_grounded = true
	
func area_exited(area: Area2D) -> void:
	if area.is_in_group("player") || \
		area.is_in_group("primary_portal") || area.is_in_group("secondary_portal"):
		return
	is_grounded = false

func _physics_process(delta: float) -> void:
	reset()
	var x: float = move()
	var jump: float = jump()
	var y: float
	if jump < 0.0:
		y = jump
	else:
		y = gravity()
	self.velocity = Vector2(x, y)
	move_and_slide()
	
func reset() -> void:
	if Input.is_action_just_pressed("reset"):
		self.global_position = start_pos
		jump_frame = 0
		is_grounded = false
		$ResetAudio.play()

func move() -> float:
	var move: float = 0
	if Input.is_action_pressed("move_left"):
		move -= 1
	if Input.is_action_pressed("move_right"):
		move += 1
	return move_speed * move
	
func gravity() -> float:
	var gravity: float = 0
	if !is_grounded: # TODO: not false
		gravity += 1
	return gravity_speed * gravity
	
func jump() -> float:
	if Input.is_action_just_pressed("jump") && is_grounded:
		jump_frame = 1
	if jump_frame > 0 && jump_frame < JUMP_UP_FRAMES:
		jump_frame += 1
		return jump_speed * -1.0
	elif jump_frame >= JUMP_UP_FRAMES && jump_frame < JUMP_UP_FRAMES + JUMP_HANG_FRAMES:
		jump_frame += 1
		return -1
	else:
		return 0.0
