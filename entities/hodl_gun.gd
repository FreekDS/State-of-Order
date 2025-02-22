extends NPCState

@export var gunSprite:Sprite2D
@export var minStateTime = 5
@export var maxStateTime = 10
@export var speechBubble : SpeechBubble

@onready var state_length: Timer = $StateLength
@onready var speech_bubble_timer: Timer = $SpeechBubbleTimer
@onready var max_single_dir_timer: Timer = $MaxSingleDirTime
var targetPoint = Vector2.ZERO

var gun_words = [
	"heavy_dollar_sign",
	"skull_and_crossbones",
	"gun",
	"rage",
	"thinking_face",
	"slightly_smiling_face",
	"no_entry"
]
var speed = 10
var active = false

func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		#NPCStateManager.STATE.WANDER_AIMLESS,
		#NPCStateManager.STATE.TALK_TO_SOMEONE,
		NPCStateManager.STATE.HIT_SOMEONE,
		NPCStateManager.STATE.SHOOT_SOMEONE,
	]
	nextStatesWeigths=[
		10,
		10, 
		50
	]


func enter():
	debug.text = "GUN"
	if !navAgent.navigation_finished.is_connected(_on_navigation_agent_2d_target_reached):
		navAgent.navigation_finished.connect(_on_navigation_agent_2d_target_reached)
	animations.play("run", -1, 1.1)
	state_length.start(randf_range(minStateTime, maxStateTime))
	speech_bubble_timer.start(randf_range(2,4))
	max_single_dir_timer.start()
	navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)
	gunSprite.visible=true


func tick(_delta: float):
	if navAgent.is_navigation_finished() or targetPoint.is_equal_approx(Vector2.ZERO):
		navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)
		targetPoint = navAgent.get_next_path_position()
	
	targetPoint = navAgent.get_next_path_position()
	
	var direction = (targetPoint - character.global_position).normalized() * speed
	character.velocity = direction


func exit():
	navAgent.navigation_finished.disconnect(_on_navigation_agent_2d_target_reached)
	max_single_dir_timer.stop()
	active = false
	gunSprite.visible=false
	state_length.stop()
	speech_bubble_timer.stop()
	if speechBubble.isOpen:
		speechBubble.close()
		
func _on_navigation_agent_2d_target_reached() -> void:
	navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)

func _on_max_single_dir_time_timeout() -> void:
	navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)


func _on_speech_bubble_timer_timeout() -> void:
	if speechBubble != null:
		speechBubble.option = gun_words.pick_random()
		speechBubble.open()
		
		get_tree().create_timer(4.0).timeout.connect(
			func():
				if speechBubble.isOpen:
					speechBubble.close()
				if active:
					speech_bubble_timer.start(randf_range(2,4))
		)


func _on_state_length_timeout() -> void:
	switchState.emit(self)
