extends Node2D

class_name Gun

var portal_scene: PackedScene

func _ready() -> void:
	portal_scene = load("res://scenes/Portal.tscn")

func _process(delta: float) -> void:
	self.look_at(get_global_mouse_position())
	portals_input()

func portals_input() -> void:
	var type: String = ""
	if Input.is_action_just_pressed("primary_action"):
		type = "primary"
	if Input.is_action_just_pressed("secondary_action"):
		type = "secondary"
	if !type.is_empty():
		var group_name: String = type + "_portal"
		var existing: Array[Node] = self.owner.owner.get_tree().get_nodes_in_group(group_name)
		for node in existing:
			node.queue_free()
		var shot = portal_scene.instantiate()
		shot.add_to_group(group_name)
		shot.position = $GunEnd.global_position
		var shot_sprite := shot.get_child(0) # TODO: better than index
		shot_sprite.texture = load("res://assets/images/" + type + "_portal.png")
		self.owner.owner.add_child(shot)
		$GunAudio.play()
