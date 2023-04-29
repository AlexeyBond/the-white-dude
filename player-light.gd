extends CharacterBody2D

class_name PlayerLight

@export var move_direction: Vector2
@export_range(0.0, 1.0) var move_velocity_factor: float = 0.0
@export var move_speed: float = 1000.0

@onready var optical_body = $optical_body

const SECONDS_PER_TAIL_PARTICLE = 0.01

func _ready():
	move_velocity_factor = 0.0
	$AnimationPlayer.play("to_light")
	velocity = Vector2.ZERO
	
	optical_body.top_level = true
	optical_body.global_position = global_position

func start_restoring_material_body():
	move_speed = 0.0
	$AnimationPlayer.play("to_body")
	$tail_emitter.emitting = false

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


var tail_emission_remainder = 0.0

func emit_tail_particles(delta):
	var emitter: GPUParticles2D = get_node("../tail_particles")
	
	if not emitter:
		return
	
	tail_emission_remainder += delta
	
	while tail_emission_remainder >= SECONDS_PER_TAIL_PARTICLE:
		tail_emission_remainder -= SECONDS_PER_TAIL_PARTICLE
		var particle_transform = Transform2D()
		
		particle_transform.origin = self.global_position
		
		emitter.emit_particle(
			particle_transform,
			Vector2.ZERO,
			Color.WHITE,
			Color.WHITE,
			GPUParticles2D.EMIT_FLAG_POSITION,
		)

#func _process(delta):
#	if move_velocity_factor > 0.01 or move_speed > 0.01:
#		emit_tail_particles(delta)


