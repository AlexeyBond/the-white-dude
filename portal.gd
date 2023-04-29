extends Node2D


@export var next_level: PackedScene


func on_player_teleported():
	owner.get_parent().change_level(next_level)


func _on_area_2d_body_entered(body):
	var player: Player = body
	var pos = player.global_position
	
	player.queue_free()
	
	$TeleportingPlayer.global_position = pos
	$TeleportingPlayer.visible = true
	
	var tw = get_tree().create_tween()
	
	tw.set_parallel(true)
	tw.tween_property(
		$TeleportingPlayer,
		"global_position",
		global_position,
		1.0,
	)
	tw.tween_property(
		$TeleportingPlayer,
		"scale",
		Vector2(0,0),
		1.0,
	)
	tw.tween_property(
		$TeleportingPlayer,
		"rotation",
		4 * PI,
		1.0,
	)
	tw.tween_callback(self.on_player_teleported).set_delay(1.0)


