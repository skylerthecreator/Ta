extends Node

const MAX_HP = 5

var coins = 0

var insta_cast_ready = false
var amnova_ready = true

var hp = 1

var fireball_unlocked = false
var glacial_unlocked = false
var blade_unlocked = false
var forbidden_unlocked = false
var amnova_unlocked = false

var insta_cast_unlocked = true
var immunity_unlocked = false

var blade_ready = true
var glacial_ready = true


func _process(_delta):
	Hud.update_hp(hp, MAX_HP)
	Hud.update_coins(coins)
	if fireball_unlocked:
		Hud.show_fireball()
	if blade_unlocked:
		Hud.show_blade()
	if glacial_unlocked:
		Hud.show_glacial()
	if insta_cast_ready and fireball_unlocked:
		Hud.show_insta_cast()
		
func blade_pressed():
	if blade_unlocked:
		Hud.blade_pressed()
func fireball_pressed():
	if fireball_unlocked:
		Hud.fireball_pressed(insta_cast_ready)
func glacial_pressed():
	if glacial_unlocked:
		Hud.glacial_pressed()
func interrupt_fireball():
	if fireball_unlocked:
		Hud.fireball_interrupted()
func reset():
	Hud.reset()
