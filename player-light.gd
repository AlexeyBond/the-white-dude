extends CharacterBody2D

class_name PlayerLight

@export var move_direction: Vector2
@export_range(0.0, 1.0) var move_velocity_factor: float = 0.0
@export var move_speed: float = 1000.0

@onready var optical_body = $optical_body

func _ready():
	move_velocity_factor = 0.0
	$AnimationPlayer.play("to_light")
	velocity = Vector2.ZERO
	
	optical_body.top_level = true
	optical_body.global_position = global_position

func start_restoring_material_body():
	move_speed = 0.0
	$AnimationPlayer.play("to_body")

func spawn_body():
	var as_body: Player = load("res://player.tscn").instantiate()
	
	as_body.global_position = global_position
	
	get_parent().add_child(as_body)
	
	queue_free()

func do_reflect(collision: KinematicCollision2D):
	move_direction = move_direction.reflect(collision.get_normal().rotated(0.5 * PI))

var last_optical_collider = null

func _physics_process(delta):
	if move_velocity_factor <= 0.01 or move_speed <= 0.01:
		return
	
	optical_body.global_position = global_position
	var movement = move_direction * move_velocity_factor * move_speed * delta

	if move_and_collide(movement) != null:
		start_restoring_material_body()
		return
	
	var optical_collision = optical_body.move_and_collide(movement)

	if optical_collision != null:
		var collider = optical_collision.get_collider()
		# Ignore repeated collisions. Without this a player may get stuck in a mirror.
		if last_optical_collider != collider:
			do_reflect(optical_collision)
			last_optical_collider = optical_collision.get_collider()
	else:
		last_optical_collider = null
