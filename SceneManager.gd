extends CanvasLayer

class_name SceneManagerRoot

@export var initial_scene: PackedScene

var callback

func do_load_next_scene():
	if callback == null:
		return

	callback.call()
	callback = null
	
	AudioEffectsManager.reset()

func change_scene(lvl):
	if lvl == null:
		return
	
	if lvl is String:
		callback = func(): get_tree().change_scene_to_file(lvl)
	elif lvl is PackedScene:
		callback = func(): get_tree().change_scene_to_packed(lvl)
	else:
		assert((not (lvl is String)) and (not (lvl is PackedScene)))

	$AnimationPlayer.play("change_scene")


func _input(event):
	if event.is_action_pressed("game_restart"):
		change_scene(initial_scene)
	elif event.is_action_pressed("game_restart_level"):
		callback = func(): get_tree().reload_current_scene()
		$AnimationPlayer.play("change_scene")



