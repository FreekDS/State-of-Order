extends NPCState

var targetPoint = Vector2.ZERO

## Just to ensure guy is not running too loong in one direction
@onready var maxSingleDirTimer: Timer = $MaxSingleDirTime

var speed = 10

func _ready():
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.TALK_TO_SOMEONE,
		NPCStateManager.STATE.SMOKING,
		NPCStateManager.STATE.PROTEST,
		NPCStateManager.STATE.WATCH_TV,
	]
	nextStatesWeigths=[
		10,
		10, 
		40, #als ze kunnen babbelen mogen ze dat doen
		10,
		8,
		.5
	]

func enter():
	debug.text = "WALK"
	if !navAgent.navigation_finished.is_connected(_on_navigation_agent_2d_target_reached):
		navAgent.navigation_finished.connect(_on_navigation_agent_2d_target_reached)
	animations.play("run", -1, 1.1)
	maxSingleDirTimer.start()
	navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)


func tick(_delta: float):
	if navAgent.is_navigation_finished() or targetPoint.is_equal_approx(Vector2.ZERO):
		navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)
		targetPoint = navAgent.get_next_path_position()
	
	targetPoint = navAgent.get_next_path_position()
	
	var direction = (targetPoint - character.global_position).normalized() * speed
	character.velocity = direction


func exit():
	navAgent.navigation_finished.disconnect(_on_navigation_agent_2d_target_reached)
	maxSingleDirTimer.stop()


func _on_navigation_agent_2d_target_reached() -> void:
	switchState.emit(self)
	#var options = [NPCStateManager.STATE.WANDER_AIMLESS, NPCStateManager.STATE.STANDSTILL,NPCStateManager.STATE.TALK_TO_SOMEONE]
	#var nextState = options.pick_random()
	#while not nextState.checkViable():
		#nextState = options.pick_random()
	#
	#if nextState != NPCStateManager.STATE.WANDER_AIMLESS:
		#switchState.emit(self, nextState)


func _on_max_single_dir_time_timeout() -> void:
	navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)
	targetPoint = navAgent.get_next_path_position()
	_on_navigation_agent_2d_target_reached()
	
func onDragEnd():
	if character.dead:
		return
	animations.play("run")
