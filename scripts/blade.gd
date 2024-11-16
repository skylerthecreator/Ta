extends Area2D
#@onready var fireball_hit = $fireball_hit
#@onready var fireball_land = $fireball_land
#@onready var fireball_blast = $fireball_blast

@onready var blade_animation = $blade_animation
@onready var blade_shape = $blade_shape

var charged = false
var SPEED = 250
var cast_dir = 0
var adjusted = false

func _physics_process(delta):
	if charged:
		if cast_dir < 0 and !adjusted:
			blade_animation.flip_h = true
			blade_shape.position.x -= 2.2
			adjusted = true
		visible = true
		blade_shape.disabled = false
		blade_animation.play("shoot")
		#blade_hit.play()
		position.x += SPEED * delta * cast_dir
	
func _on_body_entered(_body):
	queue_free()
	
	
func _on_area_entered(area):
	if area.is_in_group("enemies"):
		#areas0.append(area)
		area.hit = true
	#fireball_land.play()
	#fireball_animation.play("explode")
	charged = false
