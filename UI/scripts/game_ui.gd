extends Control


@onready var score: RichPopText = %Score
@onready var dayCounter: RichTextLabel = %DayCounter
@onready var timeLabel: RichPopText = %Time
@onready var drama= $DramatischeTekst

@export var arrowVisualizer: PanArrowVisualizer = null

var _hitEdges : Array[Vector2i] = []
var _highlighted : Array[Vector2i] = []

func _ready() -> void:
	EventBus.successfulCapture.connect(
		func(_guy, score): score.updateScore(score)
	)
	EventBus.wrongCapture.connect(
		func(_guy, score): score.updateScore(score)
	)
	
	EventBus.timeUpdated.connect(
		func(newTime: int):
			timeLabel.text = str(newTime).lpad(2, '0') + ":00"
			timeLabel.doPop()
	)
	drama.dramatiek()


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("pan_camera_up"):
		#score.updateScore(1)
	#if event.is_action_pressed("pan_camera_down"):
		#score.updateScore(-1)


#func _process(delta: float) -> void:
	#timeLabel.text = "FPS:" + str(Engine.get_frames_per_second())

func _on_camera_hit_edge(where: Vector2i) -> void:
	if _hitEdges.has(where):
		return
	_hitEdges.append(where)
	arrowVisualizer.disableEdge(where)


func _on_camera_moving(to: Vector2i) -> void:
	if _highlighted.has(to):
		return
	_highlighted.append(to)
	
	if _hitEdges.has(to):
		return
		
	arrowVisualizer.highlightEdge(to)


func _on_camera_edge_no_longer_hit(where: Vector2i) -> void:
	if _hitEdges.has(where):
		_hitEdges.erase(where)
		arrowVisualizer.restoreEdgeColor(where)
		if where in _highlighted:
			arrowVisualizer.highlightEdge(where)


func _on_camera_stationary() -> void:
	for highlight in _highlighted:
		arrowVisualizer.restoreEdgeColor(highlight)
		if highlight in _hitEdges:
			arrowVisualizer.disableEdge(highlight)
	_highlighted.clear()
