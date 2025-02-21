## Orchestrates the game sequence:
##	- Startup sequence
##	- End screen
##	- Goto next day
##	- After last day, go back to menu
extends Node2D

@export var skipIntroSequence := false
@export var dayInformation : Array[DayResource] = []

@export_category("🔗 Node links 🔗")
@export var startSequence : StartSequence
@export var dramatischeText : DramaDramaGroteLama
@export var guySpawner : GuySpawner

var currentDay = 0


func _ready() -> void:
	EventBus.timesUp.connect(_handleDayEnd)
	
	if skipIntroSequence:
		get_tree().create_timer(.5).timeout.connect(
			func():
				guySpawner.setupGame(dayInformation[currentDay])
				_on_dramatische_tekst_done()
		)
		return
	
	get_tree().create_timer(.5).timeout.connect(
			func():
				guySpawner.setupGame(dayInformation[currentDay])
	)
	startSequence.playAnimation(dayInformation[currentDay])




func _handleDayEnd():
	pass


func _on_start_day_sequence_pls_start_day() -> void:
	dramatischeText.dramatiek()


func _on_dramatische_tekst_done() -> void:
	
	EventBus.dayStarted.emit(dayInformation[currentDay])
