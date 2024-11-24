extends Node2D

var SPEED = 60
var direction = 1
const MAX_HP = 3


@onready var ray_cast_right = $RayCastRight

@onready var awalk = $walk
@onready var aattack = $attack
@onready var ahit = $hit
@onready var adie = $die

@onready var attack_time = $attack_time
@onready var attackrange = $attackrange
@onready var polygon = $attackrange/polygon
@onready var animation_player = $AnimationPlayer
@onready var healthbar = $Control/healthbar
@onready var slimedeath = $slimedeath
@onready var dmg_taken = $dmg_taken
@onready var dtdt = $dtdt
@onready var swing = $swing
@onready var C2D = $CollisionPolygon2D


var body_in_range = null
var hp = MAX_HP


# Called every frame. 'delta' is the elapsed time since the previous frame.
		
func _physics_process(delta):
	update_health()
	if hp <= 0:
		C2D.disabled = true
	if body_in_range and hp > 0:
		awalk.visible = false
		adie.visible = false
		ahit.visible = false
		aattack.visible = true
		if !aattack.is_playing():
			aattack.play("default")
			attack_time.start()
			swing.play()
			
	if ray_cast_right.is_colliding():
		direction *= -1
		scale.x *= -1
		dmg_taken.scale.x *= -1
		healthbar.scale.x *= -1
	if !(ahit.is_playing() or aattack.is_playing()) and hp > 0:
		aattack.visible = false
		adie.visible = false
		ahit.visible = false
		awalk.visible = true
		awalk.play("default")
		position.x += direction * delta * SPEED
	if dmg_taken.text != "":
		dmg_taken.position.y -= 0.4

func hit(damage: int):
	hp -= damage
	dmg_taken.text = "-" + str(damage)
	dtdt.start()
	healthbar.value = (hp * 100.0 / MAX_HP)
	if hp > 0:
		awalk.visible = false
		aattack.visible = false
		adie.visible = false
		ahit.visible = true
		ahit.play("default")
		slimedeath.play()
	else:
		awalk.visible = false
		aattack.visible = false
		ahit.visible = false
		slimedeath.play()
		adie.visible = true
		animation_player.play("die")
		adie.play("default")

func update_health():
	if hp >= MAX_HP:
		healthbar.visible = false
	else:
		healthbar.visible = true
		

func _on_dtdt_timeout():
	dmg_taken.text = ""
	dmg_taken.position.y = -39


func _on_attackrange_body_entered(body):
	if body.is_in_group("player"):
		body_in_range = body
			
func _on_attackrange_body_exited(_body):
	body_in_range = null

func _on_attack_time_timeout():
	if body_in_range and hp > 0:
		body_in_range._hit(1)



