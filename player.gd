extends CharacterBody2D

class_name Player

const SPEED = 250.0
const FALL_SPEED = 300.0
const FALL_TIME_TO_ANIMATE = 0.1

@export var disable_actions = false

@onready var sprite = $AnimatedSprite2D

@onready var walk_audio = $WalkAudioStreamPlayer

@onready var interact_left: Area2D = $interact_left
@onready var interact_right: Area2D = $interact_right

func _ready():
	sprite.play("idle-1")

var fall_time: float = 0.0

signal moved;

func _physics_process(delta):
	if not is_on_floor():
		fall_time += delta
		velocity.y = FALL_SPEED
		velocity.x = 0

		if fall_time >= FALL_TIME_TO_ANIMATE:
			sprite.animation = &"fall"
	else:
		fall_time = 0
		var direction = Input.get_axis("game_left", "game_right")
		velocity.x = direction * SPEED
		velocity.y = 0
		
		if abs(velocity.x) > 0.1:
			emit_signal("moved")
			if !walk_audio.playing:
				walk_audio.play()

		if direction:
			sprite.animation = &"walk"
		elif sprite.animation == &"walk" or sprite.animation == &"fall":
			sprite.animation = &"idle-1"

	move_and_slide()


func _on_sprite_animation_looped():
	if sprite.animation.begins_with("idle-"):
		var r = randf()
		
		if r < 0.01:
			sprite.animation = &"idle-4"
		elif r < 0.05:
			sprite.animation = &"idle-3"
		elif r < 0.15:
			sprite.animation = &"idle-2"
		else:
			sprite.animation = &"idle-1"

func _on_sprite_animation_finished():
	if sprite.animation == &"act-left":
		sprite.play(&"idle-1")
	elif sprite.animation == &"act-right":
		sprite.play(&"idle-1")

var light_scene = preload("res://player-light.tscn")

func do_transform(direction: Vector2):
	if not GameMode.plus_game_mode_enabled():
		var a = direction.angle()
		a -= fmod(a, PI * 0.5)
		direction = Vector2(1,0).rotated(a)

	var as_light = light_scene.instantiate()

	as_light.global_position = global_position
	as_light.move_direction = direction

	get_parent().add_child(as_light)

	queue_free()

func do_interact(area: Area2D, animation: StringName):
	sprite.animation = animation

	for other_area in area.get_overlapping_areas():
		other_area.interact()

func handle_action_pressed():
	if disable_actions:
		return

	if (not is_on_floor()) and (not GameMode.plus_game_mode_enabled()):
		return

	var direction = Vector2(
		Input.get_axis("game_left", "game_right"),
		Input.get_axis("game_up", "game_down")
	)

	var l = direction.length()

	if l < 0.5:
		if interact_left.has_overlapping_areas():
			do_interact(interact_left, &"act-left")
		elif interact_right.has_overlapping_areas():
			do_interact(interact_right, &"act-right")

		return

	do_transform(direction / l)

func _process(_delta):
	if Input.is_action_just_pressed("game_act"):
		handle_action_pressed()











