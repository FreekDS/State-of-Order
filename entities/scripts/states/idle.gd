extends NPCState

@export var minIdleTime = 0.5
@export var maxIdleTime = 4.0

@onready var idle_time: Timer = $IdleTime
@onready var idleEffectTimer: Timer = $IdleEffect

@export var speechBubble : SpeechBubble

var idle_words = [
	"smile",
	"heavy_dollar_sign",
	"zzz",
	"japanese_ogre",
	"skull_and_crossbones",
	"clock2",
	"bed",
	"sleeping"
]

var active = false

func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.TALK_TO_SOMEONE,
		NPCStateManager.STATE.HODL_GUN,
		NPCStateManager.STATE.SMOKING,
		NPCStateManager.STATE.SWIM_IN_FONTAIN,
	]
	nextStatesWeigths=[
		10,
		10, 
		40,
		20,
		40,
		10,
	]


func enter():
	active = true
	debug.text = "IDLE"
	animations.stop()
	idle_time.start(randf_range(minIdleTime, maxIdleTime))
	idleEffectTimer.start(randf_range(2,4))
	animations.play("idle")


func tick(_delta: float):
	character.velocity = Vector2.ZERO


func exit():
	active = false
	idleEffectTimer.stop()
	idle_time.stop()
	if speechBubble.isOpen:
		speechBubble.close()


func _on_idle_time_timeout() -> void:
	switchState.emit(self)

func _on_idle_effect_timeout() -> void:
	if speechBubble != null:
		speechBubble.option = idle_words.pick_random()
		speechBubble.open()
		
		get_tree().create_timer(4.0).timeout.connect(
			func():
				if speechBubble.isOpen:
					speechBubble.close()
				if active:
					idleEffectTimer.start(randf_range(2,4))
		)
		
