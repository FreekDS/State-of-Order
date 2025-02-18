class_name CameraController
extends Camera2D


signal hitEdge(where: Vector2i)
signal edgeNoLongerHit(where: Vector2i)
signal moving(to: Vector2i)
signal stationary

@onready var startPoint := global_position

#@export var _topLeft = Vector2(-400,-200)
#@export var _botRight = Vector2(400,200)


@export var cameraSpeed : float = 5.0

@export var zoomIncrement : float = 0.1

@export var maxZoom : float = 3
@export var minZoom : float = .5

## Size that must be reached before moving the camera is possible
@export var edgeHitThreshold : float = 10

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
			zoomIn()
	
	if event.is_action("reset_camera"):
		var tween := create_tween()
		tween.tween_property(
			self,"global_position", startPoint, .1
		)
		tween.tween_property(self, "zoom", Vector2.ONE, .1)


func _shouldMove() -> bool:
	return !_moveDirection.is_equal_approx(Vector2.ZERO)


func _isMouseOnEdge(mousePos: Vector2, edge: PanelContainer) -> bool:
	return Rect2(edge.position, edge.size).has_point(mousePos)
	
	
func _physics_process(_delta: float) -> void:
	
	var mousePos := get_viewport().get_mouse_position()
	
	_moveDirection = Vector2(
		_leftContribution(mousePos) + _rightContribution(mousePos),
		_upContribution(mousePos) + _downContribution(mousePos)
	)
	
	_sendEdgeSignals()

	if not _shouldMove(): 
		stationary.emit()
		return
	
	if abs(_moveDirection) == Vector2.ONE:
		@warning_ignore("narrowing_conversion")
		moving.emit(Vector2i(_moveDirection.x, 0))
		@warning_ignore("narrowing_conversion")
		moving.emit(Vector2i(0, _moveDirection.y))
	else:
		moving.emit(_moveDirection)

	global_translate(
		Vector2(_moveDirection.x, _moveDirection.y).normalized() * cameraSpeed 
	)


func _sendEdgeSignals():
	if _isOnLeftLimit():
		hitEdge.emit(Vector2.LEFT)
	else:
		edgeNoLongerHit.emit(Vector2.LEFT)
		
	if _isOnRightLimit():
		hitEdge.emit(Vector2.RIGHT)
	else:
		edgeNoLongerHit.emit(Vector2.RIGHT)
	
	if _isOnBotLimit():
		hitEdge.emit(Vector2.DOWN)
	else:
		edgeNoLongerHit.emit(Vector2.DOWN)
		
	if _isOnTopLimit():
		hitEdge.emit(Vector2.UP)
	else:
		edgeNoLongerHit.emit(Vector2.UP)


func _isOnLeftLimit() -> bool:
	return abs(_zoomedTopLeft().x - limit_left) < 10
	
func _isOnRightLimit() -> bool:
	return abs(_zoomedBotRight().x - limit_right) < 10
	
func _isOnTopLimit() -> bool:
	return abs(_zoomedTopLeft().y - limit_top) < 10
	
func _isOnBotLimit() -> bool:
	return abs(_zoomedBotRight().y - limit_bottom) < 10


func _leftContribution(mousePos: Vector2) -> int:
	if _isOnLeftLimit():
		return 0
	if _isMouseOnEdge(mousePos, leftEdge) or Input.is_action_pressed("pan_camera_left"):
		return -1
	return 0

func _rightContribution(mousePos: Vector2) -> int:
	if _isOnRightLimit():
		return 0
	if _isMouseOnEdge(mousePos, rightEdge) or Input.is_action_pressed("pan_camera_right"):
		return 1
	return 0


func _upContribution(mousePos: Vector2) -> int:
	if _isOnTopLimit():
		return 0
	if _isMouseOnEdge(mousePos, topEdge) or Input.is_action_pressed("pan_camera_up"):
		return -1
	return 0


func _downContribution(mousePos: Vector2) -> int:
	if _isOnBotLimit():
		return 0
	if _isMouseOnEdge(mousePos, botEdge) or Input.is_action_pressed("pan_camera_down"):
		return 1
	return 0


func _zoomedTopLeft() -> Vector2:
	return get_screen_center_position() - get_viewport_rect().size  / zoom / 2.0

func _zoomedBotRight() -> Vector2:
	return get_screen_center_position() + get_viewport_rect().size  / zoom / 2.0

func zoomIn():
	zoom -= Vector2(zoomIncrement, zoomIncrement)
	zoom = clamp(zoom, Vector2(minZoom, minZoom), Vector2(maxZoom, maxZoom))


func zoomOut():
	zoom += Vector2(zoomIncrement, zoomIncrement)
	zoom = clamp(zoom, Vector2(minZoom, minZoom), Vector2(maxZoom, maxZoom))
