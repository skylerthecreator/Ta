extends Node2D

@onready var hp = $Display/hp
@onready var coins = $Display/coins
@onready var fireball_icon = $Display/fireball_icon
@onready var fireball_casting = $Display/fireball_icon/fireball_casting
@onready var fireball_casting_time = $fireball_casting_time
@onready var insta_cast = $Display/insta_cast
@onready var fb_animation = $Display/fireball_icon/AnimatedSprite2D

@onready var mauricedialogue = $Display/mauricedialogue
@onready var dialogue = $Display/mauricedialogue/dialogue

var dialogue_queue =[]
var curr_dialogue = null
var curr_dialogue_index = 0

var fireball_ct = 1.0

func _physics_process(_delta):
	if fireball_casting.visible == true:
		fireball_casting.text = str(snapped(fireball_ct, 0.1))
		fireball_ct -= 1.0/60




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
	dialogue_queue = []
	
func continue_dialogue():
	if len(dialogue_queue) > 0:
		mauricedialogue.visible = true
		dialogue.text = dialogue_queue[0]
		dialogue_queue.remove_at(0)
	else:
		mauricedialogue.visible = false
	
func start_dialogue(dialogue_lines):
	var autostart = len(dialogue_queue) == 0
		
	for line in dialogue_lines:
		dialogue_queue.append(line)
	if autostart:
		continue_dialogue()
