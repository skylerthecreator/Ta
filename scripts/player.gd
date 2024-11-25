extends CharacterBody2D


const ROLL_SPEED = 300
var MAX_SPEED = 100
const JUMP_VELOCITY = -225
const DASH_SPEED_MULTIPLIER = 4
const PRIORITY_MOVEMENT = ["casting", "fireball", "blade", "counter", "skill1", "wake", "hit", "dash", "forbiddencasting", "forbidden", "glacial"]
const PREVENT_START = ["casting", "fireball", "blade", "counter", "forbiddencasting", "forbidden", "glacial"]
const PREVENT_FLIP = ["fireball", "blade", "counter", "forbiddencasting", "forbidden", "dash", "glacial"]
var speed = MAX_SPEED


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump = $jump
@onready var hurt = $hurt
@onready var footsteps = $footsteps
@onready var game_manager = %GameManager
@onready var death_timer = $death_timer
@onready var playeroutline = $playeroutline
@onready var immunity = $immunity
@onready var passives = $passives


@onready var s1_sound = $skill1sound
@onready var s1_cd = $skill1cd

@onready var casting_bar = $casting_bar
@onready var fireball_chargeup = $fireball_chargeup
@onready var fireball_sound = $fireball_sound
@onready var fireball_cast_time = $fireball_cast_time
@onready var fbspawn = $fbspawn
var fireball = load("res://scenes/fireball.tscn")
var blade = load("res://scenes/blade.tscn")
var forbidden = load("res://scenes/forbidden.tscn")
var glacial = load("res://scenes/glacial.tscn")
@onready var dash_duration = $dash_duration
@onready var dash_cd = $dash_cd
@onready var dash_sfx = $dash_sfx

@onready var bladespawn = $bladespawn
@onready var blade_cd = $blade_cd
@onready var blade_cast_time = $blade_cast_time
@onready var blade_shoot = $blade_shoot

@onready var forbidden_cast_time = $forbidden_cast_time
@onready var forbiddenspawn = $forbiddenspawn
@onready var forbidden_chargeup = $forbidden_chargeup
@onready var fcs = $forbiddencastsound


@onready var glacialspawn = $glacialspawn
@onready var glacial_cast_time = $glacial_cast_time
@onready var glacial_cd = $glacial_cd


var buy = false
var areas1 = []
var dead = false
var rolling = false
var waking_up = true
var attacking = false
var moving = false
var immune = false
var can_dash = true
var dashing = false

var casting = false
var cast_dir = 1
var can_jump = true
var casting_speed = 0
	
func _physics_process(delta):
	if waking_up:
		_waking_up()
	#elif animated_sprite.animation == "wake" and animated_sprite.is_playing():
	#	pass
	elif !dead:
		var direction = Input.get_axis("move_left", "move_right")
		moving = direction != 0 or !(is_on_floor())
		if moving and casting:
			_interrupt_casting()
		if casting:
			casting_bar.visible = true
			casting_bar.value += casting_speed
		# Add the gravity.
		if not is_on_floor() and not dashing:
			velocity.y += gravity * delta
		# Handle jump.
		if Input.is_action_just_pressed("continue"):
			Hud.continue_dialogue()
		if Input.is_action_just_pressed("dash"):
			_dash()
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump.play()
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("skill0"):
			_skill0()
		if Input.is_action_just_pressed("skill1"):
			_skill1()
		if Input.is_action_just_pressed("skill2"):
			_skill2()
		if Input.is_action_just_pressed("skill3"):
			_skill3()
		if Input.is_action_just_pressed("special1"):
			_special1()
		if buy:
			buy = false
		if Input.is_action_just_pressed("pickup"):
			buy = true
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		# get input direction: -1, 0, 1
		if immune:
			passives.play("immunity")
			passives.visible = true
		else:
			passives.visible = false
		# flip sprite
		_flip(direction)
		if direction != 0 and !footsteps.is_playing() and is_on_floor():
			footsteps.play()
		elif direction == 0 and footsteps.is_playing():
			footsteps.stop()
		if !is_on_floor():
			footsteps.stop()
		
		# play animations
		if ((PRIORITY_MOVEMENT.count(animated_sprite.animation) != 0) and 
		animated_sprite.is_playing()):
			pass
		else:
			_play_movement_animations(direction)
			
		if dashing:
			velocity.x = cast_dir * speed * DASH_SPEED_MULTIPLIER
		elif direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if !(animated_sprite.animation == "wake" and animated_sprite.is_playing()):
			move_and_slide()
		
	else:
		pass

func _waking_up():
	animated_sprite.play("wake")
	waking_up = false
func _hit(damage: int):
	if !immune and !dead:
		hurt.play()
		_interrupt_casting()
		game_manager.hp -= damage
		animated_sprite.play("hit")
		if game_manager.hp <= 0:
			dead = true
			_die()
		if game_manager.immunity_unlocked:
			immune = true
			immunity.start()
func _flip(direction: int):
	if PREVENT_FLIP.count(animated_sprite.animation) == 0:
		if direction > 0:
			cast_dir = direction
			animated_sprite.flip_h = false
			fireball_chargeup.flip_h = false
			if fbspawn.position.x > 0:
				fbspawn.position.x *= -1
				fireball_chargeup.position.x *= -1
			if bladespawn.position.x < 0:
				bladespawn.position.x *= -1
				forbiddenspawn.position.x *= -1
				forbidden_chargeup.scale.x *= -1
				glacialspawn.position.x *= -1
		elif direction < 0:
			cast_dir = direction
			animated_sprite.flip_h = true
			fireball_chargeup.flip_h = true
			if fbspawn.position.x < 0:
				fbspawn.position.x *= -1
				fireball_chargeup.position.x *= -1
			if bladespawn.position.x > 0:
				bladespawn.position.x *= -1
				forbiddenspawn.position.x *= -1
				forbidden_chargeup.scale.x *= -1
func _play_movement_animations(direction: int):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		

func _interrupt_casting():
	game_manager.interrupt_fireball()
	casting = false
	animated_sprite.stop()
	fireball_sound.stop()
	fireball_cast_time.stop()
	forbidden_cast_time.stop()
	forbidden_chargeup.visible = false
	fcs.stop()
	fireball_chargeup.visible = false
	forbidden_chargeup.stop()
	fireball_chargeup.stop()
	casting_bar.visible = false
	casting_bar.value = 0

func _skill1():
	if (!(animated_sprite.animation == "skill1" and animated_sprite.is_playing())
	 and game_manager.amnova_ready and game_manager.amnova_unlocked):
		s1_sound.play()
		animated_sprite.play("skill1")
		if areas1:
			for area in areas1:
				area.hit(1)
		game_manager.amnova_ready = false
		s1_cd.start()
func _on_skill_1_outline_area_entered(area):
	if area.is_in_group("enemies"):
		areas1.append(area)
func _on_skill_1_outline_area_exited(area):
	var index = areas1.find(area,0)
	if (index != -1):
		areas1.remove_at(index)
func _on_skill_1_cd_timeout():
	game_manager.amnova_ready = true

func _skill0():
	if (!(PREVENT_START.count(animated_sprite.animation) != 0 and 
	animated_sprite.is_playing()) and game_manager.fireball_unlocked):
		game_manager.fireball_pressed()
		if game_manager.insta_cast_ready:
			_fireball()
			game_manager.insta_cast_ready = false
		else:
			casting = true
			casting_speed = 5.0/3.0
			animated_sprite.play("casting")
			fireball_sound.play()
			fireball_cast_time.start()
			fireball_chargeup.visible = true
			fireball_chargeup.play("default")
func _on_fireball_cast_time_timeout():
	_fireball()
func _fireball():
	fireball_chargeup.visible = false
	var fb = fireball.instantiate()
	owner.add_child(fb)
	fb.transform = fbspawn.global_transform
	fb.cast_dir = cast_dir
	animated_sprite.play("fireball")
	casting = false
	casting_bar.visible = false
	casting_bar.value = 0
	
func _skill2():
	if (!(PREVENT_START.count(animated_sprite.animation) != 0 and 
	animated_sprite.is_playing()) and game_manager.blade_unlocked and game_manager.blade_ready):
		blade_shoot.play()
		animated_sprite.play("blade")
		blade_cast_time.start()
func _blade():
	game_manager.blade_pressed()
	var bl = blade.instantiate()
	owner.add_child(bl)
	bl.transform = bladespawn.global_transform
	bl.cast_dir = cast_dir
	game_manager.blade_ready = false
	blade_cd.start()
func _on_blade_cd_timeout():
	game_manager.blade_ready = true
func _on_blade_cast_time_timeout():
	_blade()

func _skill3():
	if (!(PREVENT_START.count(animated_sprite.animation) != 0 and 
	animated_sprite.is_playing()) and game_manager.glacial_unlocked and game_manager.glacial_ready):
		#blade_shoot.play()
		animated_sprite.play("glacial")
		glacial_cast_time.start()
func _glacial():
	game_manager.glacial_pressed()
	var g = glacial.instantiate()
	owner.add_child(g)
	g.transform = glacialspawn.global_transform
	g.cast_dir = cast_dir
	game_manager.glacial_ready = false
	glacial_cd.start()
func _on_glacial_cast_time_timeout():
	_glacial()
func _on_glacial_cd_timeout():
	game_manager.glacial_ready = true

func _special1():
	if (!(PREVENT_START.count(animated_sprite.animation) != 0 and 
	animated_sprite.is_playing()) and game_manager.forbidden_unlocked):
		#game_manager.forbidden_pressed()
		casting = true
		casting_speed = 5.0/9.0
		animated_sprite.play("forbiddencasting")
		fcs.play()
		forbidden_chargeup.visible = true
		forbidden_chargeup.play("default")
		forbidden_cast_time.start()
func _on_forbidden_cast_time_timeout():
	forbidden_chargeup.visible = false
	game_manager.hp -= 1
	var forb = forbidden.instantiate()
	owner.add_child(forb)
	forb.transform = forbiddenspawn.global_transform
	forb.cast_dir = cast_dir
	forb.charged = true
	animated_sprite.play("forbidden")
	casting = false
	casting_bar.visible = false
	casting_bar.value = 0
	if game_manager.hp <= 0:
		dead = true
		_die()

func _die():
	animated_sprite.play("death")
	death_timer.start()
func _on_death_timer_timeout():
	game_manager.reset()
	get_tree().reload_current_scene()
func _on_immunity_timeout():
	immune = false

func _dash():
	if can_dash:
		animated_sprite.play("dash")
		dash_sfx.play()
		dashing = true
		if game_manager.insta_cast_unlocked and game_manager.fireball_unlocked:
			game_manager.insta_cast_ready = true
		dash_duration.start()
		dash_cd.start()
		can_dash = false
func _on_dash_duration_timeout():
	dashing = false	
func _on_dash_cd_timeout():
	can_dash = true












