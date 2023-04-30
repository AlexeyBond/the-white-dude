extends CanvasLayer

var next_scene: PackedScene = null

func do_load_next_scene():
	if next_scene == null:
		return
	
	var current_scene = get_child(0)
	
	remove_child(current_scene)
	current_scene.call_deferred("free")

	var new_scene = next_scene.instantiate()
	add_child(new_scene)
	move_child(new_scene, 0)

	next_scene = null

func change_level(lvl: PackedScene):
	if lvl == null:
		return
	next_scene = lvl
	$AnimationPlayer.play("change_scene")
