extends CharacterBody2D

class_name Player

const SPEED = 300.0
const FALL_SPEED = 300.0
const FALL_TIME_TO_ANIMATE = 0.1

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.play("idle-1")

var fall_time: float = 0.0

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
		
		if direction:
			sprite.animation = &"walk"
		elif not sprite.animation.begins_with("idle-"):
			sprite.animation = &"idle-1"

	move_and_slide()


func _on_sprite_animation_looped():
	if sprite.animation.begins_with("idle-"):
		var r = randf()
		
		if r < 0.1:
			sprite.animation = &"idle-2"
		else:
			sprite.animation = &"idle-1"

var light_scene = preload("res://player-light.tscn")

func do_transform():
	var direction = Vector2(
		Input.get_axis("game_left", "game_right"),
		Input.get_axis("game_up", "game_down")
	)
	
	var l = direction.length()
	
	if l < 0.5:
		return
	
	direction = direction / l
	
	var as_light: PlayerLight = light_scene.instantiate()
	
	as_light.global_position = global_position
	as_light.move_direction = direction

	get_parent().add_child(as_light)

	queue_free()

func _unhandled_key_input(event: InputEvent):
	if event.is_action("game_transform"):
		do_transform()











