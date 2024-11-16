extends Node2D

@onready var hp = $Display/hp
@onready var coins = $Display/coins
@onready var fireball_icon = $Display/fireball_icon
@onready var fireball_casting = $Display/fireball_icon/fireball_casting
@onready var fireball_casting_time = $fireball_casting_time
@onready var insta_cast = $Display/insta_cast
@onready var fb_animation = $Display/fireball_icon/AnimatedSprite2D

@onready var mauricedialogue = $Display/mauricedialogue
@onready var dialogue1 = $Display/mauricedialogue/dialogue1

const dialogue1_lines = ["Ah, look who's finally awake!", 
"You don't remember who you are? That will be rather troublesome...",
"You have suffered a great injury. You must've lost your memory from it.",
"Have that healing potion on the table. Don't worry, it's a family recipe!",
"Of course, I should introduce myself. My name is Maurice, a wizard that preserves peace across this world.",
"I'm afraid for reasons I cannot say, I am unable to tell you who you are.",
"However, if you follow the path in front of you, I believe you may regain your memory.",
"In the meantime, to help you on your journey, I have left my amulet just outside. It will provide you with a layer of protection."]

var curr_dialogue = null
var curr_dialogue_index = 0

var fireball_ct = 1.0

func _physics_process(_delta):
	if fireball_casting.visible == true:
		fireball_casting.text = str(snapped(fireball_ct, 0.1))
		fireball_ct -= 1.0/60


func continue_dialogue():
	if curr_dialogue_index < len(curr_dialogue):
		mauricedialogue.visible = true
		dialogue1.text = curr_dialogue[curr_dialogue_index]
		curr_dialogue_index += 1
	else:
		mauricedialogue.visible = false

func update_hp(curr: int, max_hp: int):
	hp.text = ""
	for i in range(curr):
		hp.text += "❤️"
	for i in range(max_hp - curr):
		hp.text += "🖤"

func update_coins(c: int):
	coins.text = ""
	coins.text = "🪙x" + str(c)
	
func show_fireball():
	fireball_icon.visible = true
	#fb_animation.visible = true
	#fb_animation.play("default")
	
func fireball_pressed(instant: bool):
	fireball_icon.emit_signal("pressed")
	if !instant:
		fireball_casting.visible = true
		fireball_casting_time.start()
	else:
		insta_cast.visible = false

	
func show_insta_cast():
	insta_cast.visible = true
	insta_cast.play("default")

func fireball_interrupted():
	fireball_casting.visible = false
	fireball_casting_time.stop()
	fireball_ct = 1
	

func _on_fireball_casting_time_timeout():
	fireball_casting.visible = false
	fireball_ct = 1

func reset():
	insta_cast.visible = false
	fireball_icon.visible = false
	
func start_dialogue1():
	curr_dialogue = dialogue1_lines
	mauricedialogue.visible = true
	dialogue1.text = curr_dialogue[curr_dialogue_index]
	curr_dialogue_index += 1
