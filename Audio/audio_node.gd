extends Node2D

@export var dayAudios : Array[AudioStreamWAV] = [
	
]
@onready var music: AudioStreamPlayer = $music


func _ready() -> void:
	if not music.playing:
		music.stream = dayAudios[0]
		music.play()
	
	EventBus.daySetup.connect(_fadeDayMusic)


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
