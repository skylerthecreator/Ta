extends CharacterBody2D

const ROLL_SPEED = 300
const SPEED = 130
const JUMP_VELOCITY = -300
const MAX_HP = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump = $jump
@onready var hurt = $hurt
@onready var game_manager = %GameManager
@onready var tracker = $Camera2D/tracker
@onready var footsteps = $footsteps


var dead = false
var hit = false
var hp = 1
var coins = 0
var rolling = false
var waking_up = true
	
func _physics_process(delta):
	if waking_up:
		animated_sprite.play("wake")
		waking_up = false
	elif hit:
		hurt.play()
		animated_sprite.play("hit")
		hit = false
	elif !dead:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			jump.play()
			velocity.y = JUMP_VELOCITY
			


		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		# get input direction: -1, 0, 1
		var direction = Input.get_axis("move_left", "move_right")
		
		# flip sprite
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		if direction != 0 and !footsteps.is_playing() and is_on_floor():
			footsteps.play()
		elif direction == 0 and footsteps.is_playing():
			footsteps.stop()
		if !is_on_floor():
			footsteps.stop()
		
		# play animations
		if (animated_sprite.animation == "hit" and animated_sprite.is_playing()) or (animated_sprite.animation == "wake" and animated_sprite.is_playing()):
			pass
		else:
			if is_on_floor():
				if direction == 0:
					animated_sprite.play("idle")
				else:
					animated_sprite.play("run")

					
			else:
				animated_sprite.play("jump")

		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		tracker.text = ""
		for i in range(hp):
			tracker.text += "❤️"
		tracker.text += "\n"
		tracker.text += "🪙x" + str(game_manager.score)
		if !(animated_sprite.animation == "wake" and animated_sprite.is_playing()):
			move_and_slide()
		
	else:
		tracker.text = "💀"
		animated_sprite.play("death")


