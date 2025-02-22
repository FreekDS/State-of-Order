extends Node2D

@export var dayAudios : Array[AudioStreamWAV] = [
	
]
@onready var music: AudioStreamPlayer = $music
@onready var splashAudio: AudioStreamPlayer2D = $splash

@onready var shoot1: AudioStreamPlayer2D = $shoot1

@export var speakingFemaleAudios : Array[AudioStreamWAV] = [
	
]

@export var speakingMaleAudios : Array[AudioStreamWAV] = [
	
]


@onready var blablas: Node2D = $Blablas
@onready var clock_tick: AudioStreamPlayer = $clockTick
@onready var tring: AudioStreamPlayer = $tring
@onready var punchAudio: AudioStreamPlayer2D = $punch

@onready var deRik : AudioStreamPlayer2D = $rik

func _ready() -> void:
	if not music.playing:
		music.stream = dayAudios[0]
		music.play()
	
	EventBus.daySetup.connect(_fadeDayMusic)
	
	EventBus.timeUpdated.connect(
		func(_ignored):
			clock_tick.play()
	)
	
	EventBus.dayEnded.connect(
		func():
			tring.play()
	)


func _fadeDayMusic(dayData: DayResource):
	var idx = dayData.dayNumber - 1
	idx = clamp(idx, 0, len(dayAudios) - 1)
	
	if music.stream == dayAudios[idx]:
		return
	
	var originalVolume := music.volume_db
	var fader = music.create_tween()
	fader.tween_property(music, "volume_db", -40, .5)
	fader.play()
	await fader.finished
	
	music.stream = dayAudios[idx]
	music.play()
	var fadeIn = music.create_tween()
	fadeIn.tween_property(music, "volume_db", originalVolume, .5)
	fadeIn.play()


func _play(audio : AudioStreamPlayer2D, at: Vector2):
	audio.global_position = at
	audio.play()


func splash(at: Vector2):
	_play(splashAudio, at)

func punch(at: Vector2):
	punchAudio.pitch_scale = randf_range(.7, 1.3)
	_play(punchAudio, at)

func iShotTheSherrif(at: Vector2):
	_play(shoot1, at)


func blablaMale(at: Vector2):
	var firstSpeaker : AudioStreamPlayer2D = null
	
	for speaker : AudioStreamPlayer2D in blablas.get_children():
		if not speaker.playing:
			firstSpeaker = speaker
			break
	
	if firstSpeaker == null:
		return
	
	firstSpeaker.stream = speakingMaleAudios.pick_random()
	firstSpeaker.pitch_scale = randf_range(.9, 1.1)
	
	_play(firstSpeaker, at)

	
func blablaFemale(at: Vector2):
	var firstSpeaker : AudioStreamPlayer2D = null
	
	for speaker : AudioStreamPlayer2D in blablas.get_children():
		if not speaker.playing:
			firstSpeaker = speaker
			break
	
	if firstSpeaker == null:
		return
	
	firstSpeaker.stream = speakingFemaleAudios.pick_random()
	firstSpeaker.pitch_scale = randf_range(.9, 1.1)
	
	_play(firstSpeaker, at)

func playDeRikZijneMuziek(at: Vector2):
	_play(deRik, at)

func stopDeRikeZineMuziek():
	deRik.stop()
