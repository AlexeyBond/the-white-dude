extends Node

var _plus_game_mode_allowed: bool = false
var _plus_game_mode: bool = false
var _play_time: float = 0.0

func plus_game_mode_allowed() -> bool:
	return _plus_game_mode_allowed

func allow_plus_game_mode():
	_plus_game_mode_allowed = true

func plus_game_mode_enabled() -> bool:
	return _plus_game_mode

func set_plus_game_mode(enabled: bool):
	_plus_game_mode = enabled

func track_play_time(time: float):
	_play_time += time

func get_total_play_time() -> float:
	return _play_time

func clear_play_time():
	_play_time = 0.0
