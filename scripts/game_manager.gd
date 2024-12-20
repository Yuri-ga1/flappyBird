extends Node

var character: CharacterBody2D = null

var sfx_sounds: Array[AudioStream] = []


func add_sfx_sound(player: AudioStreamPlayer2D):
	sfx_sounds.append(player)
