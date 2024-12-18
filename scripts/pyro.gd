extends Area2D
@onready var game_manager = %GameManager
@onready var AS = $AnimatedSprite2D
@onready var vision = $vision
@onready var dmg_taken = $dmg_taken
@onready var healthbar = $Control/healthbar
@onready var attackrange = $attackrange
@onready var dtdt = $dtdt
@onready var attack_1_time = $attack_1_time
@onready var under = $UNDER
@onready var dir = $DIR
@onready var spawn_duration = $spawn_duration
var slime = load("res://scenes/actualslime.tscn")
@onready var spawn = $spawn
@onready var spawn_cd = $spawn_cd
@onready var spawn_period = $spawn_period

var SPEED = 30
var direction = 1
var MAX_HP = 15
var ds = 25
var gap = 0
var begin = false
var hp = MAX_HP

var follow_player = null
var player = null
var player2 = null
var in_range = false

var spawn_ready = true
var spawning = false
var NO_MOVE = ["attack", "spawn", "death", "hit"]
var item_dropped = false
func _physics_process(delta):
	update_health()
	if hp > 0:
		if follow_player and !follow_player.dead:
			gap = follow_player.position.x - position.x
			if gap >= 0 and !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
				direction =  1
				if AS.scale.x > 0:
					AS.scale.x *= -1
					attackrange.scale.x *= -1
					dir.scale.x *= -1
					under.position.x *= -1
			
			elif gap < 0 and !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()):
				direction = -1
				if AS.scale.x < 0:
					AS.scale.x *= -1
					attackrange.scale.x *= -1
					dir.scale.x *= -1
					under.position.x *= -1
		if !AS.is_playing():
			AS.play("idle")
		if spawning:
			spawn_period.start()
			spawning = false
		if !(NO_MOVE.count(AS.animation) != 0 and AS.is_playing()) and hp > 0 and follow_player:
			if spawn_ready:
				AS.play("spawn")
				spawn_ready = false
				spawning = true
				spawn_duration.start()
			elif in_range:
				AS.play("attack")
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
			pass
			#var b = buckler.instantiate()
			#owner.add_child(b)
			#b.transform = spawn.global_transform
			#item_dropped = true

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
	print("hit")
	hp -= damage
	dmg_taken.text = "-" + str(damage)
	dtdt.start()
	healthbar.value = (hp * 100.0 / MAX_HP)
	attack_1_time.stop()
	if hp > 0:
		if AS.animation != "spawn":
			AS.play("hit")
	else:
		AS.play("death")
		#deathanimation.play("die")
		game_manager.second_boss_complete = true

func _on_dtdt_timeout():
	dmg_taken.text = ""
	dmg_taken.position.y = -40
func _on_vision_body_entered(body):
	follow_player = body
func _on_vision_body_exited(_body):
	follow_player = null
	
func _on_attack_1_time_timeout():
	if player and hp > 0:
		player.hit(1, direction)



func _on_attackrange_body_entered(body):
	if body.is_in_group("player"):
		in_range = !body.dead
		player = body
func _on_attackrange_body_exited(body):
	if body.is_in_group("player"):
		in_range = false
		player = null




func _on_spawn_period_timeout():
	var s = slime.instantiate()
	s.direction = direction
	owner.add_child(s)
	s.transform = spawn.global_transform
	spawning = true


func _on_spawn_cd_timeout():
	spawn_ready = true


func _on_spawn_duration_timeout():
	spawning = false
	spawn_period.stop()
	spawn_cd.start()
