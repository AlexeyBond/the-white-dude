extends Area2D

@export var target_path: NodePath

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var turned: bool = false

func interact():
	var target: MovingObject = get_node(target_path)
	
	if target.is_moving:
		return
	
	if turned:
		animation_player.play_backwards("turn_on")
	else:
		animation_player.play("turn_on")
	
	turned = not turned
	
	target.start_moving()
