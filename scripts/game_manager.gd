extends Node

var character: CharacterBody2D = null
var background: CompressedTexture2D = load("res://assets/environment/background/Archaea.png")
var ground: CompressedTexture2D = load("res://assets/environment/ground/Archaea.png")

var pipe_scene: PackedScene = load("res://scenes/game_objects/pipe.tscn")


var sfx_sounds: Array[AudioStream] = []
