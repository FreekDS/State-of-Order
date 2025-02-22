class_name CharacterDragHandler
extends Node2D

var _selected : DikkeRon = null
var _mouseDown : bool = false

@export var navigationRegion : NavigationRegion2D
var dayData:DayResource

signal guyDragged(who: DikkeRon)

func _ready() -> void:
	Globals.allNpcs.clear()
	for child : DikkeRon in get_children():
		if child is not DikkeRon:
			continue

		#setupGuy(child)



func setupGuy(guy: DikkeRon, data: DayResource):
	guy.setup(navigationRegion.get_navigation_map())
	guy.helpIkBenGeselecteerd.connect(_on_select)
	guy.neverMindIkBenGedeselect.connect(_on_deselect)
	dayData = data
	Globals.allNpcs.append(guy)

func _physics_process(_delta: float) -> void:
	if _selected and _mouseDown:
		_selected.global_position = get_global_mouse_position() + Vector2(0, 16)
	


func _input(event: InputEvent) -> void:
	if _selected == null:
		return
	if event.is_action_pressed("grab_character"):
		if dayData.isKillDay:
			_selected.beKilled()
			Audio.pang()
		else:
			_selected.startDrag()
			_mouseDown = true
			EventBus.changeCursor.emit(false)
			guyDragged.emit(_selected)
	if event.is_action_released("grab_character"):
		EventBus.changeCursor.emit(true)
		_selected.endDrag()
		_mouseDown = false
	

func _on_select(who: DikkeRon):
	if _selected == null:
		EventBus.changeShootCursor.emit(false)
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
		EventBus.changeShootCursor.emit(true)
		for child : DikkeRon in get_children():
			if child is not DikkeRon:
				continue
			child.pickable = true
