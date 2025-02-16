class_name CameraController
extends Camera2D


signal hitEdge(where: Vector2i)
signal edgeNoLongerHit(where: Vector2i)
signal moving(to: Vector2i)
signal stationary

@onready var startPoint := global_position

@export var _topLeft = Vector2(-400,-200)
@export var _botRight = Vector2(400,200)

@export var maxCameraHeight : float = 100.0
@export var minCameraHeight : float = 0
@export var cameraSpeed : float = 5.0
@export var zoomIncrement : float = 1.0

## Size that must be reached before moving the camera is possible
@export var startMoveTreshold : float = 100

var _moveDirection : Vector2 = Vector2.ZERO


@onready var leftEdge : PanelContainer = $CanvasLayer/left
@onready var rightEdge: PanelContainer = $CanvasLayer/right
@onready var botEdge: PanelContainer = $CanvasLayer/bot
@onready var topEdge: PanelContainer = $CanvasLayer/top


func _input(event: InputEvent) -> void:
	if !event.is_pressed(): return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoomOut()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom()
	
	if event.is_action("reset_camera"):
		create_tween().tween_property(
			self,"global_position", startPoint, .1
		)


func _shouldMove() -> bool:
	return !_moveDirection.is_equal_approx(Vector2.ZERO)


func _isMouseOnEdge(mousePos: Vector2, edge: PanelContainer) -> bool:
	return Rect2(edge.position, edge.size).has_point(mousePos)
	
	
func _physics_process(delta: float) -> void:
	
	var mousePos := get_viewport().get_mouse_position()
	
	if _isMouseOnEdge(mousePos, leftEdge) or Input.is_action_pressed("pan_camera_left"):
		_moveDirection.x = -1
	elif _isMouseOnEdge(mousePos, rightEdge) or Input.is_action_pressed("pan_camera_right"):
		_moveDirection.x = 1
	else:
		_moveDirection.x = 0
		
	if _isMouseOnEdge(mousePos, topEdge) or Input.is_action_pressed("pan_camera_up"):
		_moveDirection.y = -1
	elif _isMouseOnEdge(mousePos, botEdge) or Input.is_action_pressed("pan_camera_down"):
		_moveDirection.y = 1
	else:
		_moveDirection.y = 0
	
	
	if not _shouldMove(): 
		stationary.emit()
		return
	
	if abs(_moveDirection) == Vector2.ONE:
		moving.emit(Vector2i(_moveDirection.x, 0))
		moving.emit(Vector2i(0, _moveDirection.y))
	else:
		moving.emit(_moveDirection)

	global_translate(
		Vector2(_moveDirection.x, _moveDirection.y).normalized() * cameraSpeed 
	)
	
	global_position.x = clamp(global_position.x, _topLeft.x, _botRight.x)
	global_position.y = clamp(global_position.y, _topLeft.y, _botRight.y)

	# Mess
	if global_position.x == _topLeft.x:
		# TODO: this is contantly emitting, not sure if that is ideal...
		hitEdge.emit(Vector2.LEFT)
	else:
		edgeNoLongerHit.emit(Vector2.LEFT)
		
	if global_position.x == _botRight.x:
		hitEdge.emit(Vector2.RIGHT)
	else:
		edgeNoLongerHit.emit(Vector2.RIGHT)
	
	if global_position.y == _botRight.y:
		hitEdge.emit(Vector2.DOWN)
	else:
		edgeNoLongerHit.emit(Vector2.DOWN)
		
	if global_position.y == _topLeft.y:
		hitEdge.emit(Vector2.UP)
	else:
		edgeNoLongerHit.emit(Vector2.UP)
	
		
		
	


func zoom():
	pass
	#camera.translate(Vector3(0.0,0.0,zoomIncrement))
	#var z := camera.position.z
	#camera.position.z = clampf(z, minCameraHeight, maxCameraHeight)

func zoomOut():
	pass
	#camera.translate(Vector3(0.0,0.0,-zoomIncrement))
	#var z := camera.position.z
	#camera.position.z = clampf(z, minCameraHeight, maxCameraHeight)
