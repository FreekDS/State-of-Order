extends Node

const vastenmen = preload("res://Textures/and_grijpe.png")
const normaal = preload("res://Textures/andje.png")
const shoot = preload("res://Textures/shoot.png")

const HOTSPOT = Vector2(16, 15)
var dayData: DayResource
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.daySetup.connect(_daydata)
	EventBus.changeCursor.connect(changeSprit)
	Input.set_custom_mouse_cursor(normaal)
	

func changeSprit(normal : bool) -> void:
	if dayData.isKillDay:
		return
	if normal:
		Input.set_custom_mouse_cursor(normaal, Input.CURSOR_ARROW, HOTSPOT)
	else:
		Input.set_custom_mouse_cursor(vastenmen, Input.CURSOR_ARROW, HOTSPOT)
		
func _daydata(data:DayResource):
	dayData=data
	if dayData.isKillDay:
		Input.set_custom_mouse_cursor(shoot, Input.CURSOR_ARROW, HOTSPOT)
	else:
		Input.set_custom_mouse_cursor(normaal, Input.CURSOR_ARROW, HOTSPOT)
		
	
