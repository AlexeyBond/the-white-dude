extends Node

var history: GameHistory
var _plus_game_mode: bool = false
var _play_time: float = 0.0

const history_file_path = "user://game_history.tres"

func load_history():
	if ResourceLoader.exists(history_file_path):
		history = load(history_file_path)
	elif history != null:
		history = GameHistory.new()


func save_history():
	ResourceSaver.save(history, history_file_path)


func _ready():
	load_history()

func plus_game_mode_allowed() -> bool:
	return history.plus_mode_unlocked

func allow_plus_game_mode():
	history.plus_mode_unlocked = true
	save_history()

func plus_game_mode_enabled() -> bool:
	return _plus_game_mode

func set_plus_game_mode(enabled: bool):
	_plus_game_mode = enabled

func track_play_time(time: float):
	_play_time += time

func get_total_play_time() -> float:
	return _play_time

func get_best_score() -> float:
	return history.best_score

func clear_play_time():
	_play_time = 0.0

func save_score():
	if history.best_score <= 0.0 or history.best_score > _play_time:
		history.best_score = _play_time
		save_history()
