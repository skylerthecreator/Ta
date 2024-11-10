extends CharacterBody2D


const ROLL_SPEED = 300
const SPEED = 100
const JUMP_VELOCITY = -225
const MAX_HP = 5
const PRIORITY_MOVEMENT = ["skill1", "wake", "hit"]

var speed = SPEED
var hp = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump = $jump
@onready var hurt = $hurt
@onready var game_manager = %GameManager
@onready var tracker = $Camera2D/tracker
@onready var footsteps = $footsteps
@onready var s1 = $skill1sound
@onready var skill_1_cd = $skill1cd



# signal facing_dir_changed(facing_right : bool)
var buy = false
var areas = []

var dead = false
var hit = false
var coins = 0
var rolling = false
var waking_up = true
var attacking = false
var attack_ready = true
var skill1 = false
	
func _physics_process(delta):
	if waking_up:
		_waking_up()
	elif hit:
		_hit()
	elif !dead:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump.play()
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("skill1"):
			_skill1()
		if buy:
			buy = false
		if Input.is_action_just_pressed("pickup"):
			buy = true
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		# get input direction: -1, 0, 1
		var direction = Input.get_axis("move_left", "move_right")
		# flip sprite
		_flip(direction)
		if direction != 0 and !footsteps.is_playing() and is_on_floor():
			footsteps.play()
		elif direction == 0 and footsteps.is_playing():
			footsteps.stop()
		if !is_on_floor():
			footsteps.stop()
		
		# play animations
		if (PRIORITY_MOVEMENT.count(animated_sprite.animation) != 0) and animated_sprite.is_playing():
			pass
		else:
			_play_movement_animations(direction)
			
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		_update_tracker()
		if !(animated_sprite.animation == "wake" and animated_sprite.is_playing()):
			move_and_slide()
		
	else:
		tracker.text = "🖤🖤🖤🖤🖤" + "\n" + "🪙x" + str(game_manager.score)
		animated_sprite.play("death")

func _waking_up():
	animated_sprite.play("wake")
	waking_up = false
func _hit():
	hurt.play()
	animated_sprite.play("hit")
	hit = false
func _update_tracker():
	tracker.text = ""
	for i in range(hp):
		tracker.text += "❤️"
	for i in range(MAX_HP - hp):
		tracker.text += "🖤"
	tracker.text += "\n"
	tracker.text += "🪙x" + str(game_manager.score)
	
func _skill1():
	if !(animated_sprite.animation == "skill1" and animated_sprite.is_playing()) and attack_ready and skill1:
		s1.play()
		animated_sprite.play("skill1")
		if areas:
			for area in areas:
				area.hit = true
		attack_ready = false
		skill_1_cd.start()

func _flip(direction: int):
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
func _play_movement_animations(direction: int):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")


func _on_skill_1_outline_area_entered(area):
	if area.is_in_group("enemies"):
		areas.append(area)


func _on_skill_1_outline_area_exited(area):
	var index = areas.find(area,0)
	if (index != -1):
		areas.remove_at(index)


func _on_skill_1_cd_timeout():
	attack_ready = true
