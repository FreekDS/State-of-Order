extends Node

var vastenmen = load("res://Textures/and_grijpe.png")
var normaal = load("res://Textures/andje.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.changeCursor.connect(changeSprit)
	Input.set_custom_mouse_cursor(normaal)
	

func changeSprit(normal : bool) -> void:
	if normal:
		Input.set_custom_mouse_cursor(normaal)
	else:
		Input.set_custom_mouse_cursor(vastenmen)
