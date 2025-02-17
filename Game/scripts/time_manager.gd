extends Node

## In seconds
@export var dayDuration = 120

@export_range(0,24) var startTime = 6
@export_range(0,24) var endTime = 23

@onready var timer: Timer = $Timer

var _currentHour = 0
var _secondsPerTick := 0.0

func _ready() -> void:
	_secondsPerTick = dayDuration / float(endTime - startTime)
	_currentHour = startTime
	
	var updateTime = func(): EventBus.timeUpdated.emit(_currentHour)
	updateTime.call_deferred()
	
	timer.start(_secondsPerTick)


func _on_timer_timeout() -> void:
	_currentHour += 1
	EventBus.timeUpdated.emit(_currentHour)
	
	if _currentHour >= endTime:
		EventBus.timesUp.emit()
		return
	
	timer.start(_secondsPerTick)
