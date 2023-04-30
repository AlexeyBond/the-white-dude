extends Node2D

class_name SpeechBubble

@export var chars_per_second: float = 50
@export var visibility_duration: float = 1.0

@onready var rtl = $Panel/RichTextLabel
@onready var panel = $Panel

var tw: Tween = null
var speaking = false

func do_hide():
	panel.visible = false
	panel.modulate = Color(1,1,1,0)
	speaking = false


func _ready():
	do_hide()


func say(text: String):
	rtl.visible_ratio = 0
	rtl.text = text
	panel.visible = true
	
	if tw != null:
		tw.stop()
	
	speaking = true
	
	tw = get_tree().create_tween()
	
	tw.tween_property(
		panel, "modulate:a",
		1.0, 0.2
	)
	tw.tween_property(
		rtl, "visible_ratio",
		1.0,
		len(text) / chars_per_second,
	)
	tw.tween_interval(visibility_duration)
	tw.tween_property(
		panel, "modulate:a",
		0.0, 0.2
	)
	tw.tween_callback(self.do_hide)

func is_speaking():
	return speaking



