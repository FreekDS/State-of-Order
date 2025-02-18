extends NPCState

var targetPoint = Vector2.ZERO

## Just to ensure guy is not running too loong in one direction
@onready var maxSingleDirTimer: Timer = $MaxSingleDirTime

var speed = 35

func enter():
	debug.text = "WALK"
	navAgent.navigation_finished.connect(_on_navigation_agent_2d_target_reached)
	animations.play("run", -1, 1.1)
	maxSingleDirTimer.start()


func tick():
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
	var options = [NPCStateManager.STATE.WANDER_AIMLESS, NPCStateManager.STATE.STANDSTILL]
	var next = options.pick_random()
	
	if next != NPCStateManager.STATE.WANDER_AIMLESS:
		switchState.emit(self, next)


func _on_max_single_dir_time_timeout() -> void:
	navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)
	targetPoint = navAgent.get_next_path_position()
	_on_navigation_agent_2d_target_reached()
