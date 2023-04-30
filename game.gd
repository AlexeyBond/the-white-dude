extends CanvasLayer

@export var initial_scene: PackedScene

var current_scene: PackedScene = null
var next_scene: PackedScene = null

func _ready():
	do_load_scene(initial_scene)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func do_load_scene(scene: PackedScene):
	var new_scene = scene.instantiate()
	add_child(new_scene)
	move_child(new_scene, 0)
	current_scene = scene

func do_load_next_scene():
	if next_scene == null:
		return

	var current = get_child(0)

	remove_child(current)
	current.call_deferred("free")

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



