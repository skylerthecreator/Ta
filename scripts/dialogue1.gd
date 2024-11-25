extends Area2D

@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Ah, look who's finally awake!", 
"You don't remember who or where you are?... What a peculiar case...",
"You have suffered a great injury. You must've lost your memory from it.",
"I prepared you a healing potion. Don't worry, it's a family recipe!",
"My name is Maurice. I am a council member of the organization responsible for preserving peace across this land, Vatereo.",
"I believe whoever had inflicted this wound upon you is likely also the one that summoned me here...",
"Your body was found past the restricted boundary where only a select number of powerful sorcerers are allowed entry.",
"By the time I had arrived, you were alone.",
"I have the ability to sense all beings up to the Dreadlands, but I could not detect anyone else.",
"Unfortunately, there aren't many known cures for memory loss.",
"Your best chance would be to follow the path in front of you, which leads further into the restricted zone.",
"The one who did this to you likely escaped to the Dreadlands.",
"Take my amulet. It will provide you with a layer of great protection."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Maurice")
		started = true
