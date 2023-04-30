extends Area2D

@export var target_path: NodePath

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var turned: bool = false

func interact():
	var target: MovingObject = get_node(target_path)
	
	if target.is_moving:
		return
	
	if turned:
		sprite.play("turn-on")
	else:
		sprite.play_backwards("turn-on")
	
	turned = not turned

	target.start_moving()


func _process(_delta):
	if (not get_node(target_path).is_moving) and has_overlapping_areas():
		$help_label.enable()
	else:
		$help_label.disable()
