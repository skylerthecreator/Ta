extends Area2D
@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["These wild berries will heal you if you are injured, or grant two coins otherwise.",
"Riea and Ezekiel are well-known merchants who scavange goods and sell them to travelers like yourself.",
"They have shops all over Vatereo. You may run into them quite often, selling their newest findings.",
"These items will grant you unique powers, but be sure to spend wisely, as they are known to be quite greedy..."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Maurice")
		started = true
