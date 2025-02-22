class_name TuimelaarSpawner
extends Node
const TUIMELAAR = preload("res://entities/Tuimelaar.tscn")
var dayData : DayResource

@export var targetNode: Node2D
@export var navmap : NavigationRegion2D

@onready var spawnTimer: Timer=$spawnTimer

func _ready() -> void:
	EventBus.daySetup.connect(_daydata)
	EventBus.timesUp.connect(
		func(): 
			if not dayData.noGuys:
				spawnTimer.stop()
				for child in targetNode.get_children():
					child.queue_free()
	)
	
func setupGame(_dayData: DayResource):
	if not _dayData.noGuys:
		return
		
	var navmapId := navmap.get_navigation_map()
	for i in range(15):
		var targetLocation := NavigationServer2D.map_get_random_point(navmapId, 1, true)
		spawnTuimelaar(targetLocation)
	spawnTimer.start()

func _daydata(data:DayResource):
	dayData=data
	
func spawnTuimelaar(at: Vector2) -> DikkeRon:
	if not dayData.noGuys:
		return
	var guyInstance := TUIMELAAR.instantiate()
	targetNode.add_child(guyInstance)
	guyInstance.global_position = at
	return guyInstance


func _on_spawn_timer_timeout() -> void:
	var navmapId := navmap.get_navigation_map()
	var targetLocation := NavigationServer2D.map_get_random_point(navmapId, 1, true)
	spawnTuimelaar(targetLocation)
	spawnTimer.start()
