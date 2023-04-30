extends Area2D

@onready var help_label = $help_label
@onready var collider = $CollisionShape2D
@onready var speech_buble: SpeechBubble = $speech_bubble

func _process(_delta):
	collider.disabled = speech_buble.is_speaking()

	if has_overlapping_areas():
		help_label.enable()
	else:
		help_label.disable()


func interact():
	var time = Time.get_date_dict_from_system()

	if time.weekday == 3:
		speech_buble.say("It's wednesday, my dude")
	else:
		speech_buble.say("It's not wednesday, dude")

