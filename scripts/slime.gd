extends Node2D

const SPEED = 60
var direction = 1
const HEALTH = 3

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var mob = $mob
@onready var animation_player = $AnimationPlayer
@onready var ray_cast_below = $RayCastBelow
@onready var ray_cast_below_2 = $RayCastBelow2



var hp = HEALTH

# Called every frame. 'delta' is the elapsed time since the previous frame.
		
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if hp > 0:
		position.x += direction * delta * SPEED
	if !(animated_sprite.animation == "hit" and animated_sprite.is_playing()) and hp > 0:
		animated_sprite.play("default")
	if mob.hit and hp > 1:
		animated_sprite.play("hit")
		hp -= 1
		mob.hit = false
	elif mob.hit:
		hp -= 1
		animated_sprite.play("die")
		animation_player.play("die")
		
	
		


