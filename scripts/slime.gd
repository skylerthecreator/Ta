extends Node2D

const SPEED = 60
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

var body_in_range = null
var attacking = false
var hit = false
var hp = MAX_HP


# Called every frame. 'delta' is the elapsed time since the previous frame.
		
func _physics_process(delta):
	update_health()
	if body_in_range and hp > 0:
		awalk.visible = false
		adie.visible = false
		ahit.visible = false
		aattack.visible = true
		aattack.play("default")
		if !body_in_range.dead and !attacking:
			attacking = true
			attack_time.start()
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
	if dmg_taken.text == "-1":
		dmg_taken.position.y -= 0.4

func update_health():
	if hit:
		hp -= 1
		dmg_taken.text = "-1"
		dtdt.start()
		healthbar.value = (hp * 100.0 / MAX_HP)
		if hp > 0:
			awalk.visible = false
			aattack.visible = false
			adie.visible = false
			ahit.visible = true
			ahit.play("default")
			slimedeath.play()
			hit = false
		else:
			awalk.visible = false
			aattack.visible = false
			ahit.visible = false
			slimedeath.play()
			adie.visible = true
			animation_player.play("die")
			adie.play("default")
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
		body_in_range._hit()
		attacking = false



