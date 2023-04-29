extends Node2D

class_name MovingObject

var transforms: Array[Transform2D] = []
var current_index: int = 0

var is_moving: bool = false

@export var auto_move: bool = false

signal started;
signal stopped;

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		transforms.append(child.global_transform)
	
	if auto_move:
		start_moving()

func do_done_moving():
	is_moving = false

	emit_signal("stopped")
	
	if auto_move:
		start_moving()

func start_moving():
	if is_moving:
		return

	current_index = (current_index + 1) % len(transforms)

	emit_signal("started")
	
	var tw = get_tree().create_tween()

	tw.tween_property(
		get_child(0),
		"global_transform",
		transforms[current_index],
		1.0,
	)
	
	is_moving = true
	
	tw.tween_callback(
		self.do_done_moving,
	)
