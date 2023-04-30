extends Node

var _plus_game_mode: bool = false

func plus_game_mode_enabled() -> bool:
	return _plus_game_mode

func set_plus_game_mode(enabled: bool):
	_plus_game_mode = enabled
