extends Area2D

class_name Portal

@export var move_speed: float = 10.0

var moving: bool = true

func _ready() -> void:
	self.look_at(get_global_mouse_position())
	self.connect("area_entered", area_check)
	
func area_check(area: Area2D) -> void:
	if moving:
		if area.is_in_group("primary_portal") || area.is_in_group("secondary_portal"):
			area.queue_free()
		else:
			moving = false
	else:
		if area.is_in_group("player"):
			var target_group: String = ""
			if self.is_in_group("primary_portal"):
				target_group = "secondary_portal"
			elif self.is_in_group("secondary_portal"):
				target_group = "primary_portal"
			if !target_group.is_empty():
				var target_portal := self.get_parent().get_tree().get_first_node_in_group(target_group) as Portal
				if target_portal && !target_portal.moving:
					var player := area.owner as Player
					player.global_position = target_portal.global_position + Vector2(0, -75)
					player.is_grounded = false
					player.jump_frame = 0

func _physics_process(delta: float) -> void:
	if moving:
		self.move_local_x(move_speed)
