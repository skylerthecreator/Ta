extends Area2D

@onready var dmg_tracker = $dmg_tracker
@onready var body = $AnimatedSprite2D
@onready var dtdt = $dtdt
var hp = 0
var SPEED = 0

func _physics_process(_delta):
	if !(body.animation == "hit" and body.is_playing()):
		body.play("default")
	if dmg_tracker.text != "":
		dmg_tracker.position.y -= 0.4

func hit(damage: int):
	body.play("hit")
	dmg_tracker.text = "-" + str(damage)
	dtdt.start()

func _on_dtdt_timeout():
	dmg_tracker.text = ""
	dmg_tracker.position.y = -22
