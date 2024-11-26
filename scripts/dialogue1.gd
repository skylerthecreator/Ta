extends Area2D

@onready var game_manager = %GameManager

var started = false

const dialogue_lines = ["Ah, look who's finally awake!", 
"You don't remember who or where you are?... What a peculiar case...",
"My name is Maurice. I am a council member of the organization responsible for preserving peace across Vatereo.",
"I received an anonymous tip of your whereabouts, but when I arrived, there was no one else around.",
"You were in the restricted zone where only a select number of powerful sorcerers are allowed entry.",
"Someone summoned me ",
"You have suffered a great injury. You must've lost your memory from it.",
"I've placed a healing potion next to you. Drink up, you'll feel much better.",
"Unfortunately, there aren't many known cures for memory loss.",
"Your best chance would be to follow the path in front of you, which leads further into the restricted zone.",
"The one who did this to you likely escaped to the Dreadlands.",
"Take my amulet. It will provide you with a layer of great protection."]

func _on_body_entered(body):
	if body.is_in_group("player") and !started:
		Hud.start_dialogue(dialogue_lines, "Maurice")
		started = true
