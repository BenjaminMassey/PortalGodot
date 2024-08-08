extends Node2D

var music: AudioStreamPlayer2D

func _ready() -> void:
	music = $LevelOneMusic as AudioStreamPlayer2D
	music.play()
	music.connect("finished", func replay(): music.play())
