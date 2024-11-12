extends Area2D

@onready var dmg_tracker = $dmg_tracker
@onready var body = $AnimatedSprite2D
@onready var dtdt = $dtdt

var hit = false

func _physics_process(delta):
	update_health()
	if !(body.animation == "hit" and body.is_playing()):
		body.play("default")
	if dmg_tracker.text == "-1":
		dmg_tracker.position.y -= 0.4

func update_health():
	if hit:
		body.play("hit")
		dmg_tracker.text = "-1"
		dtdt.start()
		hit = false



func _on_dtdt_timeout():
	dmg_tracker.text = ""
	dmg_tracker.position.y = -22
