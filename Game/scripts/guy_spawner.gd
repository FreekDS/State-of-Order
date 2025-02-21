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


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		setupGame()


@onready var SpawnDelay: Timer = $SpawnDelay
@onready var spawnMarker: Marker2D = $SpawnMarker


func setupGame():
	var navmapId := navmap.get_navigation_map()
	for i in range(amountOfInitialGuysOnMap):
		var targetLocation := NavigationServer2D.map_get_random_point(navmapId, 1, true)
		var guy := spawnGuy(targetLocation)
		guy.stateManager.enforceState(NPCStateManager.STATE._WAIT_DAYSTART)
		
	$PollGuyCount.start()



func spawnGuy(at: Vector2) -> DikkeRon:
	var guyInstance := GUY_SCENE.instantiate() as DikkeRon
	targetNode.add_child(guyInstance)
	guyInstance.global_position = at
	targetNode.setupGuy(guyInstance)
	return guyInstance


func _on_poll_guy_count_timeout() -> void:
	if len(Globals.allNpcs) < maxGuysInScene and SpawnDelay.is_stopped():
		var at = spawnMarker.global_position
		at.x += randf_range(-200, 200)
		var guy := spawnGuy(at)
		
		guy.stateManager.enforceState(
			NPCStateManager.STATE.INCOMING
		)
		
		var maxDelay = lerp(
			minSpawnDelay, maxSpawnDelay, Globals.allNpcs.size() / maxGuysInScene)
		
		SpawnDelay.start(randf_range(minSpawnDelay, maxDelay))
		
		
		# TODO: set state to INCOMING
