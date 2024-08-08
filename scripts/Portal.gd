extends Area2D

class_name Portal

@export var move_speed: float = 10.0

var moving: bool = true

func _ready() -> void:
	self.look_at(get_global_mouse_position())
	self.connect("area_entered", area_check)
	
func area_check(area: Area2D) -> void:
	if !moving:
		return
	if area.is_in_group("primary_portal") || area.is_in_group("secondary_portal"):
		area.queue_free()
	else:
		moving = false

func _physics_process(delta: float) -> void:
	if moving:
		self.move_local_x(move_speed)
