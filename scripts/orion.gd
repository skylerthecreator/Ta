extends Area2D
@onready var dmg_taken = $dmg_taken
@onready var dtdt = $dtdt
@onready var AS = $AnimatedSprite2D
@onready var healthbar = $Control/healthbar

@onready var startfightsfx = $startfightsfx

@onready var dir = $DIR
@onready var under = $UNDER

@onready var attackrange = $attackrange

@onready var attack_1_range = $attack1range
@onready var attack_1_time = $attack1_time
@onready var attack_1_sound = $attack1_sound
@onready var attack_1_vl = $attack1vl

@onready var attack_2_range = $attack2range
@onready var attack_2_time = $attack2_time
@onready var attack_2_cd = $attack2_cd
@onready var attack_2_sound = $attack2_sound
@onready var attack_2_vl = $attack2vl

@onready var deathanimation = $deathanimation
@onready var hitsfx = $hit
@onready var enragedfx = $fx

@onready var game_manager = %GameManager
var buckler = load("res://scenes/mkbuckler.tscn")
@onready var spawn = $spawn

@onready var shield = $shield/shieldarea


var SPEED = 30
var direction = 1
var MAX_HP = 1

var begin = false
var hp = MAX_HP
#var hit = false

var follow_player = null
var player = null
var player2 = null
var in_range = false

var attack_2_ready = true
var defending = false
var NO_MOVE = ["attack1", "attack2", "attack3", "death", "hit", "defend"]

func _physics_process(delta):
	update_health()
	if hp <= MAX_HP / 2.0:
		enragedfx.visible = true
		enragedfx.play("default")
		SPEED = 45
	if hp == 10 or hp == 5:
		AS.play("defend")
		defending = true
	defending = AS.animation == "defend"
	shield.disabled = AS.animation != "defend"
	if follow_player:
		var gap = follow_player.position.x - position.x
		if gap >= 0 and !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
			direction =  1
			if AS.scale.x < 0:
				AS.scale.x *= -1
			if attack_1_range.scale.x > 0:
				attack_1_range.scale.x *= -1
				attack_2_range.scale.x *= -1
				attackrange.scale.x *= -1
				enragedfx.scale.x *= -1
				dir.scale.x *= -1
				under.position.x *= -1
				shield.position.x *= -1
				
		elif gap < 0 and !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
			direction = -1
			if AS.scale.x > 0:
				AS.scale.x *= -1
			if attack_1_range.scale.x < 0:
				attack_1_range.scale.x *= -1
				enragedfx.scale.x *= -1
				attack_2_range.scale.x *= -1
				attackrange.scale.x *= -1
				dir.scale.x *= -1
				under.position.x *= -1
				shield.position.x *= -1
	else:
		AS.play("idle")

	if !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()) and hp > 0 and in_range:
		if attack_2_ready and !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
			attack_2_vl.play()
			AS.play("attack2")
			attack_2_time.start()
		elif !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
			attack_1_vl.play()
			AS.play("attack1")
			attack_1_time.start()
	if !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()) and hp > 0 and follow_player:
		AS.play("walk")
		if !under.is_colliding():
			position.y += 0.4
		if dir.is_colliding():
			position.y -= 0.4
		position.x += direction * delta * SPEED
		
		
		
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
	attack_1_time.stop()
	attack_2_time.stop()
	if hp > 0:
		hitsfx.play()
		AS.play("hit")
	else:
		AS.play("death")
		deathanimation.play("die")
		var b = buckler.instantiate()
		owner.add_child(b)
		b.transform = spawn.global_transform

func _on_dtdt_timeout():
	dmg_taken.text = ""
	dmg_taken.position.y = -55
func _on_vision_body_entered(body):
	startfightsfx.play()
	if body.is_in_group("player"):
		follow_player = body
func _on_vision_body_exited(_body):
	follow_player = null

func _on_attack_1_range_body_entered(body):
	if body.is_in_group("player"):
		player = body
func _on_attack_1_range_body_exited(_body):
	player = null
func _on_attack_1_time_timeout():
	attack_1_sound.play()
	if player and hp > 0:
		player._hit(1)


func _on_attack_2_range_body_entered(body):
	if body.is_in_group("player"):
		player2 = body
func _on_attack_2_range_body_exited(_body):
	player2 = null
func _on_attack_2_time_timeout():
	attack_2_cd.start()
	attack_2_ready = false
	attack_2_sound.play()
	if player2 and hp > 0:
		player2._hit(2)
func _on_attack_2_cd_timeout():
	attack_2_ready = true



func _on_attackrange_body_entered(body):
	if body.is_in_group("player"):
		in_range = !body.dead
func _on_attackrange_body_exited(body):
	if body.is_in_group("player"):
		in_range = false


