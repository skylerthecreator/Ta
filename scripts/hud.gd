extends Node2D

@onready var hp = $Display/hp
@onready var coins = $Display/coins
@onready var fireball_icon = $Display/fireball_icon
@onready var fireball_casting = $Display/fireball_icon/fireball_casting
@onready var fireball_casting_time = $fireball_casting_time
@onready var insta_cast = $Display/insta_cast
@onready var fb_animation = $Display/fireball_icon/AnimatedSprite2D

var fireball_ct = 1.0

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
	
func _physics_process(_delta):
	if fireball_casting.visible == true:
		fireball_casting.text = str(snapped(fireball_ct, 0.1))
		fireball_ct -= 1.0/60
	
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
