extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Overcome these obstacles. I will meet you on the other side."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Maurice")
		started = true
