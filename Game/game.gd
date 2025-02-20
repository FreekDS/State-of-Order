extends Node2D

var vastenmen = load("res://Textures/and_grijpe.png")
var normaal = load("res://Textures/andje.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(vastenmen)
