class_name Draggable extends Node2D

@export var bounds: Node2D;

var moiseInHois=false

var beingDragged=false

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if Rect2(bounds.global_position,bounds.shape.size).has_point(get_global_mouse_position()):
		moiseInHois=true
	if beingDragged:
		get_parent().position=get_global_mouse_position()
	
func _input(event):
	if event.is_action_pressed("drag") and can_drag():
		start_drag()
	if event.is_action_released("drag") and beingDragged:
		stop_drag()
		
func can_drag():
	return moiseInHois
	
func start_drag():
	beingDragged = true
	
func stop_drag():
	beingDragged = false
