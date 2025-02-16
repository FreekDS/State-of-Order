extends Control


@onready var score: RichPopText = %Score
@onready var dayCounter: RichTextLabel = %DayCounter
@onready var timeLabel: RichTextLabel = %Time


@export var arrowVisualizer: PanArrowVisualizer = null


# TODO: change to score update
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pan_camera_up"):
		score.updateScore(1)
	if event.is_action_pressed("pan_camera_down"):
		score.updateScore(-1)
