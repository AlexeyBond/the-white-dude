extends CanvasLayer

class_name Game

@export var initial_scene: PackedScene

var current_scene: PackedScene = null
var next_scene: PackedScene = null

@onready var wrapper: Node = $current_scene_wrapper

func _ready():
	do_load_scene(initial_scene)

func do_load_scene(scene: PackedScene):
	for child in wrapper.get_children():
		wrapper.remove_child(child)
		child.call_deferred("free")

	var new_scene = scene.instantiate()
	wrapper.add_child(new_scene)
	current_scene = scene

func do_load_next_scene():
	if next_scene == null:
		return

	do_load_scene(next_scene)
	next_scene = null

func change_level(lvl: PackedScene):
	if lvl == null:
		return
	next_scene = lvl
	$AnimationPlayer.play("change_scene")


func _input(event):
	if event.is_action_pressed("game_restart"):
		change_level(initial_scene)
	elif event.is_action_pressed("game_restart_level"):
		change_level(current_scene)



