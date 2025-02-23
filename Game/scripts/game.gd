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
@export var tuimelaarSpawner : TuimelaarSpawner

@export var thanksForPlaying : RichTextLabel

var currentDay = 3


func _ready() -> void:
	EventBus.timesUp.connect(_handleTimeUp)
	
	if skipIntroSequence:
		get_tree().create_timer(.5).timeout.connect(
			func():
				EventBus.daySetup.emit(dayInformation[currentDay])
				guySpawner.setupGame(dayInformation[currentDay])
				tuimelaarSpawner.setupGame(dayInformation[currentDay])
				_on_dramatische_tekst_done()
		)
		return
	
	get_tree().create_timer(.5).timeout.connect(
			func():
				EventBus.daySetup.emit(dayInformation[currentDay])
				guySpawner.setupGame(dayInformation[currentDay])
				tuimelaarSpawner.setupGame(dayInformation[currentDay])
	)
	startSequence.playAnimation(dayInformation[currentDay])


func _handleTimeUp():
	EventBus.dayEnded.emit()


func _on_start_day_sequence_pls_start_day() -> void:
	dramatischeText.dramatiek()


func _on_dramatische_tekst_done() -> void:
	EventBus.dayStarted.emit(dayInformation[currentDay])
	
	if currentDay == len(dayInformation) -1:
		get_tree().create_timer(6.0).timeout.connect(
			func(): thanksForPlaying.show()
		)


func _on_end_of_day_sequence_done() -> void:
	# SETUP NEXT DAY AND START
	currentDay += 1
	if currentDay >= len(dayInformation):
		print("EINDE SPEL, GEDAAN MET SPELEN")
		get_tree().change_scene_to_file("res://UI/Menu.tscn")
		return
		
	guySpawner.clear()
	tuimelaarSpawner.clear()
	
	EventBus.daySetup.emit(dayInformation[currentDay])
	guySpawner.setupGame(dayInformation[currentDay])
	tuimelaarSpawner.setupGame(dayInformation[currentDay])
	startSequence.playAnimation(dayInformation[currentDay])
