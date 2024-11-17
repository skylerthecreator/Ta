extends Area2D
#@onready var fireball_hit = $fireball_hit
#@onready var fireball_land = $fireball_land
#@onready var fireball_blast = $fireball_blast

@onready var blade_animation = $blade_animation
@onready var blade_shape = $blade_shape
@onready var timeintile = $timeintile
@onready var hit = $hit

var SPEED = 250
var cast_dir = 0

func _physics_process(delta):
	if cast_dir < 0:
		blade_animation.flip_h = true
	visible = true
	blade_shape.disabled = false
	blade_animation.play("shoot")
	position.x += SPEED * delta * cast_dir
	
	
func _on_area_entered(area):
	if area.is_in_group("enemies"):
		hit.play()
		area.hit(2)


func _on_body_entered(body):
	SPEED = 10
	timeintile.start()


func _on_timeintile_timeout():
	queue_free()
