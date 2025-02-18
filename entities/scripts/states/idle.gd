extends NPCState

@export var minIdleTime = 0.5
@export var maxIdleTime = 4.0

@onready var idle_time: Timer = $IdleTime
@onready var idleEffectTimer: Timer = $IdleEffect

@export var speechBubble : SpeechBubble

var idle_words = [
	"🙂",
	"💲",
	"💤",
	"🐱‍🐉",
	"...",
	"☠",
	"🕙",
	"🛌",
	"😴"
]

var active = false

func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.TALK_TO_SOMEONE
	]


func enter():
	active = true
	debug.text = "IDLE"
	animations.stop()
	idle_time.start(randf_range(minIdleTime, maxIdleTime))
	idleEffectTimer.start(randf_range(2,4))
	animations.play("idle")


func tick():
	character.velocity = Vector2.ZERO


func exit():
	active = false
	idleEffectTimer.stop()
	idle_time.stop()
	if speechBubble.isOpen:
		speechBubble.close()


func _on_idle_time_timeout() -> void:
	switchState.emit(self)
	#var nextState = possibleNextStates.pick_random()
	#while not nextState.checkViable():
		#nextState = possibleNextStates.pick_random()
		
	#if nextState != NPCStateManager.STATE.STANDSTILL:
		#switchState.emit(self, nextState)
		#return
	#idle_time.start(randf_range(minIdleTime, maxIdleTime))
	


func _on_idle_effect_timeout() -> void:
	if speechBubble != null:
		print("HUH")
		speechBubble.option = idle_words.pick_random()
		speechBubble.open()
		
		get_tree().create_timer(4.0).timeout.connect(
			func():
				if speechBubble.isOpen:
					speechBubble.close()
				if active:
					idleEffectTimer.start(randf_range(2,4))
		)
		
