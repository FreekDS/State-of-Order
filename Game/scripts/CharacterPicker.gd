class_name CharacterDragHandler
extends Node2D

var _selected : DikkeRon = null
var _mouseDown : bool = false

@export var navigationRegion : NavigationRegion2D


signal guyDragged(who: DikkeRon)

func _ready() -> void:
	
	for child : DikkeRon in get_children():
		if child is not DikkeRon:
			continue
		
		child.setup(navigationRegion.get_navigation_map())
		
		child.helpIkBenGeselecteerd.connect(_on_select)
		child.neverMindIkBenGedeselect.connect(_on_deselect)


func _physics_process(delta: float) -> void:
	if _selected and _mouseDown:
		_selected.global_position = get_global_mouse_position() + Vector2(0, 16)
	


func _input(event: InputEvent) -> void:
	if _selected == null:
		return
	if event.is_action_pressed("grab_character"):
		_selected.startDrag()
		_mouseDown = true
		guyDragged.emit(_selected)
	if event.is_action_released("grab_character"):
		_selected.endDrag()
		_mouseDown = false
	

func _on_select(who: DikkeRon):
	if _selected == null:
		_selected = who
		for child : DikkeRon in get_children():
			if child is not DikkeRon or child == who:
				continue
			child.pickable = false
		


func _on_deselect(who: DikkeRon):
	if _mouseDown:
		return
	if who == _selected:
		_selected = null
		for child : DikkeRon in get_children():
			if child is not DikkeRon:
				continue
			child.pickable = true
