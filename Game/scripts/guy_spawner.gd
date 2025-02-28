class_name GuySpawner
extends Node

const GUY_SCENE = preload("res://entities/DikkeRon.tscn")

@export var maxGuysInScene = 40

@export var maxTimeBetweenSpawns = 10
@export var minTimeBetweenSpawns = 1


@export var maxSpawnDelay : float = 7
@export var minSpawnDelay : float = 2

@export var amountOfInitialGuysOnMap = 8

@export_category("Node references 😎")
@export var targetNode : CharacterDragHandler
@export var navmap : NavigationRegion2D


#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#setupGame()


@onready var SpawnDelay: Timer = $SpawnDelay
@onready var spawnMarker: Marker2D = $SpawnMarker

var dayData : DayResource

func _ready() -> void:
	EventBus.daySetup.connect(_daydata)
	EventBus.timesUp.connect(
		func(): 
			$PollGuyCount.stop()
			SpawnDelay.stop()
			for child in targetNode.get_children():
				if child is not DikkeRon:
					continue
				if child.stateManager._stateType == NPCStateManager.STATE.DEAD:
					continue
				child.stateManager.enforceState(NPCStateManager.STATE.LEAVING)
	)

func setupGame(_dayData: DayResource):
	if _dayData.noGuys:
		return
	var navmapId := navmap.get_navigation_map()
	for i in range(amountOfInitialGuysOnMap):
		var targetLocation := NavigationServer2D.map_get_random_point(navmapId, 1, true)
		var guy := spawnGuy(targetLocation)
		guy.stateManager.enforceState(NPCStateManager.STATE._WAIT_DAYSTART)
		
	$PollGuyCount.start()

func clear():
	for child in targetNode.get_children():
		if child is DikkeRon:
			if child.stateManager._stateType == NPCStateManager.STATE.DEAD:
				# Keep the dead bodies :)
				continue
			child.queue_free()


func spawnGuy(at: Vector2) -> DikkeRon:
	if dayData.noGuys:
		return
	var guyInstance := GUY_SCENE.instantiate() as DikkeRon
	targetNode.add_child(guyInstance)
	guyInstance.global_position = at
	targetNode.setupGuy(guyInstance,dayData)
	return guyInstance


func _on_poll_guy_count_timeout() -> void:
	if SpawnDelay.is_stopped():
		var at = spawnMarker.global_position
		at.x += randf_range(-200, 200)
		var guy := spawnGuy(at)
		
		guy.stateManager.enforceState(
			NPCStateManager.STATE.INCOMING
		)
	
		@warning_ignore("integer_division")
		var maxDelay = lerp(minSpawnDelay, maxSpawnDelay, Globals.aliveNPCCount() / maxGuysInScene)
		
		SpawnDelay.start(randf_range(minSpawnDelay, maxDelay))


func _daydata(data:DayResource):
	dayData=data
