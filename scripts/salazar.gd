extends Area2D
#var battery = load("res://scenes/battery.tscn")
#@onready var batteryspawn = $batteryspawn
@onready var vision = $vision
@onready var AS = $AnimatedSprite2D
@onready var attack_1_range = $attack1range
@onready var healthbar = $healthbar
@onready var dmg_taken = $dmg_taken
@onready var dtdt = $dtdt
@onready var die = $die
@onready var attackwaittime = $attackwaittime

var SPEED = 20
var direction = 1
var MAX_HP = 20

var hp = MAX_HP
#var hit = false

var follow_player = null
var player = null
var dead = false
var NO_MOVE = ["attack", "death", "hit"]

func _physics_process(delta):
	if !dead:
		update_health()
		if follow_player:
			var gap = follow_player.position.x - position.x
			if gap > 0 and !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
				direction =  1
				if AS.scale.x > 0:
					AS.scale.x *= -1
					AS.rotation *= -1
					die.scale.x *= -1
					attack_1_range.scale.x *= -1					
			elif gap < 0 and !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
				direction = -1
				if AS.scale.x < 0:
					AS.scale.x *= -1
					AS.rotation *= -1
					die.scale.x *= -1
					attack_1_range.scale.x *= -1
					
		else:
			AS.play("idle")

		if player and !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()) and hp > 0:
			if !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
				AS.play("attack")
				attackwaittime.start()
		if !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()) and hp > 0 and follow_player:
			AS.play("walk")
			position.x += direction * delta * SPEED
	else:
		if !AS.is_playing():
			AS.visible = false;
		if !die.is_playing():
			queue_free()
			
		
		
func update_health():
	if hp >= MAX_HP:
		healthbar.visible = false
	else:
		healthbar.visible = true
	if dmg_taken.text != "":
		dmg_taken.position.y -= 0.4
	else:
		dmg_taken.position.y = -55

func hit(damage: int):
	hp -= damage
	dmg_taken.text = "-" + str(damage)
	dtdt.start()
	healthbar.value = (hp * 100.0 / MAX_HP)
	if hp > 0:
		AS.play("hit")
	else:
		die.visible = true
		AS.play("hit")
		die.play("die")
		dead = true;

		#var b = battery.instantiate()
		#owner.add_child(b)
		#b.transform = batteryspawn.global_transform

func _on_dtdt_timeout():
	dmg_taken.text = ""
	dmg_taken.position.y = -100
	
func _on_vision_body_entered(body):
	if body.is_in_group("player"):
		follow_player = body
func _on_vision_body_exited(_body):
	follow_player = null

func _on_attack_1_range_body_entered(body):
	if body.is_in_group("player"):
		player = body
func _on_attack_1_range_body_exited(_body):
	player = null






func _on_attackwaittime_timeout():
	if player:
		player._hit(1)
	attackwaittime.start()
