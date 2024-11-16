extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["These wild berries will heal you if you are injured, or grant two coins otherwise."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines)
		started = true
