extends Area2D
@onready var dmg_taken = $dmg_taken
@onready var dtdt = $dtdt
@onready var AS = $AnimatedSprite2D
@onready var healthbar = $Control/healthbar
@onready var swing = $swing

@onready var attackrange = $attackrange

@onready var attack_1_range = $attack1range
@onready var attack_1_time = $attack1_time



const SPEED = 30
var direction = 1
var MAX_HP = 20

var begin = false
var hp = MAX_HP
var hit = false

var follow_player = null
var player = null
var in_range = false

var NO_MOVE = ["attack1", "attack2", "attack3", "death"]

func _physics_process(delta):
	
	update_health()
	if follow_player:
		var gap = follow_player.position.x - position.x
		if gap >= 0 and !(AS.animation == "attack1" and AS.is_playing()):
			direction =  1
			scale.x = -1
			healthbar.scale.x = 1
		elif gap < 0 and !(AS.animation == "attack1" and AS.is_playing()):
			direction = -1
			scale.x = 1
	else:
		AS.play("idle")

	if player and hp > 0 and in_range:
		if !(AS.animation == "attack1" and AS.is_playing()):
			AS.play("attack1")
			attack_1_time.start()
			swing.play()

	if !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()) and hp > 0 and follow_player:
		AS.play("walk")
		position.x += direction * delta * SPEED
		
		
		
func update_health():
	if hit:
		hp -= 1
		dmg_taken.text = "-1"
		dtdt.start()
		healthbar.value = (hp * 100.0 / MAX_HP)
		if hp > 0:
			hit = false
		else:
			hit = false
			AS.play("death")
	if hp >= MAX_HP:
		healthbar.visible = false
	else:
		healthbar.visible = true
	if dmg_taken.text == "-1":
		dmg_taken.position.y -= 0.4


func _on_dtdt_timeout():
	dmg_taken.text = ""
	dmg_taken.position.y = -57


func _on_vision_body_entered(body):
	if body.is_in_group("player"):
		follow_player = body
		


func _on_attack_1_range_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_attack_1_range_body_exited(_body):
	player = null


func _on_attack_1_time_timeout():
	if player and hp > 0:
		player._hit()


func _on_attackrange_body_entered(body):
	if body.is_in_group("player"):
		in_range = true


func _on_attackrange_body_exited(body):
	if body.is_in_group("player"):
		in_range = false
