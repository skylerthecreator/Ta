extends CharacterBody2D


const ROLL_SPEED = 300
var MAX_SPEED = 100
const JUMP_VELOCITY = -225
const DASH_SPEED_MULTIPLIER = 5
const PRIORITY_MOVEMENT = ["casting", "fireball", "skill1", "wake", "hit", "dash"]
const PREVENT_START = ["casting", "fireball"]
const PREVENT_FLIP = ["fireball"]
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

@onready var fireball_bar = $fireball_bar
@onready var fireball_chargeup = $fireball_chargeup
@onready var fireball_sound = $fireball_sound
@onready var fireball_cast_time = $fireball_cast_time
@onready var fbspawn = $fbspawn
var fireball = load("res://scenes/fireball.tscn")

@onready var dash_duration = $dash_duration
@onready var dash_cd = $dash_cd
@onready var dash_sfx = $dash_sfx


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
	
func _physics_process(delta):
	if waking_up:
		_waking_up()
	#elif animated_sprite.animation == "wake" and animated_sprite.is_playing():
	#	pass
	elif !dead:
		var direction = Input.get_axis("move_left", "move_right")
		moving = direction != 0 or !(is_on_floor())
		if moving and casting:
			_interrupt_skill0()
		if casting:
			fireball_bar.visible = true
			fireball_bar.value += 5.0/3.0
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
		_interrupt_skill0()
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
		elif direction < 0:
			cast_dir = direction
			animated_sprite.flip_h = true
			fireball_chargeup.flip_h = true
			fbspawn.scale.x = 1
			if fbspawn.position.x < 0:
				fbspawn.position.x *= -1
				fireball_chargeup.position.x *= -1
func _play_movement_animations(direction: int):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		

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
func _skill2():
	if (!(PREVENT_START.count(animated_sprite.animation) != 0 and 
	animated_sprite.is_playing()) and game_manager.blade_unlocked):
		pass
	
func _skill0():
	if (!(PREVENT_START.count(animated_sprite.animation) != 0 and 
	animated_sprite.is_playing()) and game_manager.fireball_unlocked):
		game_manager.fireball_pressed()
		if game_manager.insta_cast_ready:
			_fireball()
			game_manager.insta_cast_ready = false
		else:
			casting = true
			animated_sprite.play("casting")
			fireball_sound.play()
			fireball_cast_time.start()
			fireball_chargeup.visible = true
			fireball_chargeup.play("default")

func _interrupt_skill0():
	game_manager.interrupt_fireball()
	casting = false
	animated_sprite.stop()
	fireball_sound.stop()
	fireball_cast_time.stop()
	fireball_chargeup.visible = false
	fireball_chargeup.stop()
	fireball_bar.visible = false
	fireball_bar.value = 0
	
func _on_fireball_cast_time_timeout():
	_fireball()
func _fireball():
	fireball_chargeup.visible = false
	var fb = fireball.instantiate()
	owner.add_child(fb)
	fb.transform = fbspawn.global_transform
	fb.cast_dir = cast_dir
	fb.charged = true
	animated_sprite.play("fireball")
	casting = false
	fireball_bar.visible = false
	fireball_bar.value = 0

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
		if game_manager.insta_cast_unlocked:
			game_manager.insta_cast_ready = true
		dash_duration.start()
func _on_dash_duration_timeout():
	dash_cd.start()
	dashing = false
	can_dash = false
	
func _on_dash_cd_timeout():
	can_dash = true


