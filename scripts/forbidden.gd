extends Area2D

@onready var shape = $shape
@onready var explode = $explode


var charged = false
var SPEED = 500
var cast_dir = 0
var exploding = false

func _physics_process(delta):
	if exploding:
		shape.disabled = true
	elif charged:
		if cast_dir < 0:
			explode.flip_h = true
		visible = true
		shape.disabled = false
		position.x += SPEED * delta * cast_dir
	if exploding and !explode.is_playing():
		queue_free()
	
#func _on_body_entered(_body):
	#moving.visible = false
	#charged = false
	
func _on_area_entered(area):
	explode.visible = true
	charged = false
	exploding = true
	if area.is_in_group("enemies") and !area.is_in_group("ineffective"):
		area.hit(area.MAX_HP)
	explode.visible = true
	explode.play("default")
	charged = false
