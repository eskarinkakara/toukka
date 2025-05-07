extends Node
 
var scores: Array = []
const SAVE_PATH := "user://leaderboard.json"
 
func _init():
	load_scores()
 
func add_score(player_name: String, survival_time: float) -> void:
	scores.append({ "name": player_name, "time": survival_time })
	scores.sort_custom(func(a, b): return b["time"] < a["time"])  # Descending
	save_scores()
 
func get_top_scores(count: int = 10) -> Array:
	return scores.slice(0, count)
 
func save_scores() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(scores))
		file.close()
 
func load_scores() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		scores = JSON.parse_string(data) if data != "" else []
		file.close()
