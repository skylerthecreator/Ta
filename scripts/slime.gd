extends Node2D

const SPEED = 60
var direction = 1
const MAX_HP = 3

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D
@onready var mob = $mob
@onready var animation_player = $AnimationPlayer
@onready var ray_cast_below = $RayCastBelow
@onready var ray_cast_below_2 = $RayCastBelow2
@onready var healthbar = $healthbar
@onready var slimedeath = $slimedeath





var hp = MAX_HP

# Called every frame. 'delta' is the elapsed time since the previous frame.
		
func _process(delta):
	update_health()
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	if !(animated_sprite.animation == "hit" and animated_sprite.is_playing()) and hp > 0:
		animated_sprite.play("default")
		position.x += direction * delta * SPEED


	
func update_health():
	if mob.hit:
		hp -= 1
		healthbar.value = (hp * 100 / MAX_HP)
		if hp > 0:
			animated_sprite.play("hit")
			slimedeath.play()
			mob.hit = false
		else:
			animated_sprite.play("die")
			animation_player.play("die")
	if hp >= MAX_HP:
		healthbar.visible = false
	else:
		healthbar.visible = true
		


