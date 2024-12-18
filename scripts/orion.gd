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
var ds = 25
var gap = 0
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
var item_dropped = false
func _physics_process(delta):
	update_health()
	if hp > 0:
		if hp <= MAX_HP / 2.0:
			enragedfx.visible = true
			enragedfx.play("default")
			SPEED = 45
		if hp == 10 or hp == 5:
			AS.play("defend")
			defending = true
		defending = AS.animation == "defend"
		shield.disabled = AS.animation != "defend"

		if follow_player and !follow_player.dead:
			gap = follow_player.position.x - position.x

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
				#attack_1_vl.play()
				AS.play("attack1")
				attack_1_time.start()
		if !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()) and hp > 0 and follow_player and abs(gap) >= 5:
			AS.play("walk")
			if !under.is_colliding():
				position.y += delta * SPEED
			if dir.is_colliding():
				position.y -= delta * SPEED
			position.x += direction * delta * SPEED
	else:
		if !item_dropped:
			var b = buckler.instantiate()
			owner.add_child(b)
			b.transform = spawn.global_transform
			item_dropped = true

func update_health():
	healthbar.visible = false if hp >= MAX_HP else true
	if dmg_taken.text != "":
		dmg_taken.position.x += ds * -0.1 if dmg_taken.horizontal_alignment == HORIZONTAL_ALIGNMENT_LEFT else ds * 0.1
		ds = ds * 0.9
		dmg_taken.position.y += 0.4
	else:
		dmg_taken.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT if gap >= 0 else HORIZONTAL_ALIGNMENT_RIGHT
		dmg_taken.position.x = -25
		dmg_taken.position.y = -40
		ds = 25

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
		game_manager.first_boss_complete = true

func _on_dtdt_timeout():
	dmg_taken.text = ""
	dmg_taken.position.y = -40
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
		player.hit(1, direction)


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
		player2.hit(2, direction)
func _on_attack_2_cd_timeout():
	attack_2_ready = true



func _on_attackrange_body_entered(body):
	if body.is_in_group("player"):
		in_range = !body.dead
func _on_attackrange_body_exited(body):
	if body.is_in_group("player"):
		in_range = false


