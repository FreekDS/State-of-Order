class_name CharacterDragHandler
extends Node2D

var _selected : DikkeRon = null
var _mouseDown : bool = false


func _ready() -> void:
	
	for child : DikkeRon in get_children():
		if child is not DikkeRon:
			continue
		
		child.helpIkBenGeselecteerd.connect(_on_select)
		child.neverMindIkBenGedeselect.connect(_on_deselect)


func _physics_process(delta: float) -> void:
	if _selected and _mouseDown:
		_selected.global_position = get_global_mouse_position() + Vector2(0, 16)
	


func _input(event: InputEvent) -> void:
	if _selected == null:
		return
	if event.is_action_pressed("grab_character"):
		_mouseDown = true
	if event.is_action_released("grab_character"):
		_mouseDown = false
	

func _on_select(who: DikkeRon):
	if _selected == null:
		_selected = who
		# TODO: maak alle andere characters unpickable


func _on_deselect(who: DikkeRon):
	if _mouseDown:
		return
	if who == _selected:
		_selected = null
		# TODO: maak alle andere characters pickable
