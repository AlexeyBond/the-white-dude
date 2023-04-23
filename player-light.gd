extends CharacterBody2D

class_name PlayerLight

@export var move_direction: Vector2
@export_range(0.0, 1.0) var move_velocity_factor: float = 0.0
@export var move_speed: float = 2000.0

func _ready():
	move_velocity_factor = 0.0
	$AnimationPlayer.play("to_light")
	velocity = Vector2.ZERO

func start_restoring_material_body():
	move_speed = 0.0
	$AnimationPlayer.play("to_body")

func spawn_body():
	var as_body: Player = load("res://player.tscn").instantiate()
	
	as_body.global_position = global_position
	
	get_parent().add_child(as_body)
	
	queue_free()

func _physics_process(delta):
	if move_velocity_factor <= 0.01 or move_speed <= 0.01:
		return

	var collision = move_and_collide(
		move_direction * move_velocity_factor * move_speed * delta
	)

	if collision != null:
		start_restoring_material_body()
