extends Node

const MAX_HP = 5

var coins = 0
var amnova_unlocked = false
var fireball_unlocked = false
var insta_cast_unlocked = false
var insta_cast_ready = false
var amnova_ready = true
var immunity_unlocked = false
var hp = 1

var blade_unlocked = true

func _process(_delta):
	Hud.update_hp(hp, MAX_HP)
	Hud.update_coins(coins)
	if fireball_unlocked:
		Hud.show_fireball()
	if blade_unlocked:
		Hud.show_blade()
	if insta_cast_ready:
		Hud.show_insta_cast()
		
func blade_pressed():
	if blade_unlocked:
		Hud.blade_pressed()
		
func fireball_pressed():
	if fireball_unlocked:
		Hud.fireball_pressed(insta_cast_ready)
func interrupt_fireball():
	if fireball_unlocked:
		Hud.fireball_interrupted()
func reset():
	Hud.reset()
