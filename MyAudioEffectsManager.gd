extends Node

class_name MyAudioEffectsManager

const HARD_BODY_EQ_TWEEN_DELAY_IN = 0.3
const HARD_BODY_EQ_TWEEN_DURATION_IN = 0.2
const HARD_BODY_EQ_TWEEN_DURATION_OUT = 0.1


var in_hard_body_filter: AudioEffectEQ21 = load("res://sound/in_hard_body_eq.tres")
@onready var hard_body_eq_tween: Tween = null
var hard_body_eq_enabling = false
var hard_body_eq_disabling = true


var in_body_filter_intensity: float = 0.0 : set = set_in_body_filter_intensity

func set_in_body_filter_intensity(k: float):
	in_body_filter_intensity = k

	var bus = AudioServer.get_bus_index("Master")
	var effect: AudioEffectEQ21 = AudioServer.get_bus_effect(bus, 0)
	
	for i in range(effect.get_band_count()):
		effect.set_band_gain_db(
			i,
			k * in_hard_body_filter.get_band_gain_db(i),
		)

func enable_in_hard_body_sound():
	if hard_body_eq_enabling:
		return
	if hard_body_eq_tween != null:
		hard_body_eq_tween.stop()
	hard_body_eq_tween = get_tree().create_tween()
	hard_body_eq_tween.tween_interval(HARD_BODY_EQ_TWEEN_DELAY_IN)
	hard_body_eq_tween.tween_property(
			self, "in_body_filter_intensity", 1.0, HARD_BODY_EQ_TWEEN_DURATION_IN
		)
	hard_body_eq_enabling = true
	hard_body_eq_disabling = false

func disable_in_hard_body_sound():
	if hard_body_eq_disabling:
		return
	if hard_body_eq_tween != null:
		hard_body_eq_tween.stop()
	hard_body_eq_tween = get_tree().create_tween()
	hard_body_eq_tween.tween_property(
			self, "in_body_filter_intensity", 0.0, HARD_BODY_EQ_TWEEN_DURATION_OUT
		)
	hard_body_eq_disabling = true
	hard_body_eq_enabling = false

func clear_in_hard_body_sound():
	set_in_body_filter_intensity(0.0)
	hard_body_eq_disabling = false
	hard_body_eq_enabling = false


var light_sound_volume: float:
	set(value):
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("LightPlayerSound"),
			value
		)
	get:
		return AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("LightPlayerSound")
		)



func reset():
	disable_in_hard_body_sound()

	light_sound_volume = -80




