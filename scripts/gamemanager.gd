extends Node

const MAX_HP = 5

var coins = 0
var amnova_unlocked = false
var fireball_unlocked = true
var amnova_ready = true
var hp = 5


func _process(_delta):
	Hud.update_hp(hp, MAX_HP)
	Hud.update_coins(coins)
	if fireball_unlocked:
		Hud.show_fireball()
		
func fireball_pressed():
	if fireball_unlocked:
		Hud.fireball_pressed()
func interrupt_fireball():
	if fireball_unlocked:
		Hud.fireball_interrupted()
