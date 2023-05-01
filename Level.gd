extends Node2D

class_name Level

func _process(delta):
	GameMode.track_play_time(delta)

func _ready():
	InGameUi.visible = true

func _exit_tree():
	InGameUi.visible = false
