extends Node2D

@onready var hp = $Display/hp
@onready var coins = $Display/coins
@onready var fireball_icon = $Display/fireball_icon
#@onready var fireball_casting = $Display/fireball_icon/fireball_casting
#@onready var fireball_casting_time = $fireball_casting_time
@onready var insta_cast = $Display/fireball_icon/insta_cast

@onready var blade_icon = $Display/blade_icon
@onready var blade_cooldown = $Display/blade_icon/blade_cooldown
@onready var blade_cooldown_time = $blade_cooldown_time

@onready var dialogue_box = $Display/dialogue_box
@onready var dialogue = $Display/dialogue_box/dialogue
@onready var npcname = $Display/dialogue_box/name

@onready var glacial_icon = $Display/glacial_icon
@onready var glacial_cooldown = $Display/glacial_icon/glacial_cooldown
@onready var glacial_cooldown_time = $glacial_cooldown_time

@onready var block_icon = $Display/block_icon
@onready var block_cooldown = $Display/block_icon/block_cooldown
@onready var block_cooldown_time = $block_cooldown_time


const MAURICEPFP = preload("res://assets/sprites/NPCS/Wizard Pack/mauricepfp.png")
const RIEAPFP = preload("res://assets/sprites/NPCS/Merchant Pack/riea3pfp.png")

var dialogue_queue =[]
var curr_dialogue = null
var curr_dialogue_index = 0

var fireball_ct = 0
var blade_cd = 0
var glacial_cd = 0
var block_cd = 0

func _ready():
	reset()
func _physics_process(_delta):
	if blade_cooldown.visible:
		blade_cooldown.text = str(snapped(blade_cd, 0.1))
		blade_cd -= 1.0/60
	if glacial_cooldown.visible:
		glacial_cooldown.text = str(snapped(glacial_cd, 0.1))
		glacial_cd -= 1.0/60
	if block_cooldown.visible:
		block_cooldown.text = str(snapped(block_cd, 0.1))
		block_cd -= 1.0/60
func update_hp(curr: int, max_hp: int):
	hp.text = ""
	for i in range(curr):
		hp.text += "♥️"
	for i in range(max_hp - curr):
		hp.text += "🖤"
func update_coins(c: int):
	coins.text = ""
	coins.text = "x" + str(c)
	
func show_fireball():
	fireball_icon.visible = true
func fireball_pressed(instant: bool):
	if instant:
		insta_cast.visible = false
	#if !instant:
		#pass
		##fireball_ct = fireball_casting_time.wait_time
		##fireball_casting_time.start()
	#else:
		#insta_cast.visible = false
#func fireball_interrupted():
	#pass
	#fireball_casting.visible = false
	#fireball_casting_time.stop()
	#fireball_ct = 1
#func _on_fireball_casting_time_timeout():
	#fireball_casting.visible = false
	#fireball_ct = fireball_casting_time.wait_time

func show_blade():
	blade_icon.visible = true
func blade_pressed():
	blade_cooldown.visible = true
	blade_cd = blade_cooldown_time.wait_time
	blade_cooldown_time.start()
func _on_blade_cooldown_time_timeout():
	blade_cooldown.visible = false
	blade_cd = blade_cooldown_time.wait_time

func show_glacial():
	glacial_icon.visible = true
func glacial_pressed():
	glacial_cooldown.visible = true
	glacial_cd = glacial_cooldown_time.wait_time
	glacial_cooldown_time.start()
func _on_glacial_cooldown_time_timeout():
	glacial_cooldown.visible = false
	glacial_cd = glacial_cooldown_time.wait_time

func show_insta_cast():
	insta_cast.visible = true
	insta_cast.play("default")
func reset():
	insta_cast.visible = false
	fireball_icon.visible = false
	blade_icon.visible = false
	glacial_icon.visible = false
	block_icon.visible = false
	dialogue_queue = []
func continue_dialogue():
	if len(dialogue_queue) > 0:
		var next_line = dialogue_queue[0]
		dialogue_box.visible = true
		npcname.text = next_line[1]
		if next_line[1] == "Maurice":
			dialogue_box.icon = MAURICEPFP
		elif next_line[1] == "Riea":
			dialogue_box.icon = RIEAPFP
		dialogue.text = next_line[0]
		dialogue_queue.remove_at(0)
	else:
		dialogue_box.visible = false	
func start_dialogue(dialogue_lines, npc):
	var autostart = len(dialogue_queue) == 0
	for line in dialogue_lines:
		dialogue_queue.append([line, npc])
	if autostart:
		continue_dialogue()

func show_block():
	block_icon.visible = true
func block_pressed():
	block_cooldown.visible = true
	block_cd = block_cooldown_time.wait_time
	block_cooldown_time.start()
func _on_block_cooldown_time_timeout():
	block_cooldown.visible = false
	block_cd = block_cooldown_time.wait_time





