extends NPCState

@export var detectOthers : Area2D

@export var speechBubble : SpeechBubble

@onready var talkLengthTimer : Timer = $TalkLengthTimer
@onready var talkBubbleTimer : Timer = $TalkBubbleTimer

@export var minTalkTime = 5
@export var maxTalkTime = 10

var neighbourchosen : DikkeRon
var babbel_words = [
	"🙂",
	"💲",
	"☠",
	"🕙",
	"😁",
	"🤨",
	"👺",
	"👌",
	"🤔",
	"👂",
	"👄",
	"🗣"
]
var active = false
func _ready() -> void:
	possibleNextStates = [
		#NPCStateManager.STATE.STANDSTILL, 
		#NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.HIT_SOMEONE,
		#NPCStateManager.STATE.TALK_TO_SOMEONE
	]

func enter():
	if neighbourchosen:
		debug.text = "PRATEN initiate"
		neighbourchosen.stateManager.enforceState(NPCStateManager.STATE.TALK_TO_SOMEONE)
		talkLengthTimer.start(randf_range(minTalkTime, maxTalkTime))
	else:
		debug.text = "PRATEN follow"
		# als ge niet initiator zijt dan  wacht ge het max
		talkLengthTimer.start(maxTalkTime)
	
	
	animations.play("idle")
	talkBubbleTimer.start(randf_range(1,2))
	active = true
	speechBubble.option = babbel_words.pick_random()
	speechBubble.open()

func tick():
	character.velocity = Vector2.ZERO

func exit():
	neighbourchosen=null
	active = false
	talkLengthTimer.stop()
	talkBubbleTimer.stop()
	if speechBubble.isOpen:
		speechBubble.close()

func checkViable() -> bool:
	var buren = detectOthers.burenGraag()
	for buur in buren:
		if NPCStateManager.STATE.TALK_TO_SOMEONE in buur.stateManager.getViableNextStates():
			neighbourchosen = buur
			return true
	neighbourchosen = null
	return false

func _on_talk_length_timer_timeout() -> void:
	if not active:
		return
	#Dit niet doen, circular dependencies paniek
	#if neighbourchosen:
		#neighbourchosen.stateManager.enforceNextState()
	switchState.emit(self)


func _on_talk_bubble_timer_timeout() -> void:
	if speechBubble != null:
		speechBubble.option = babbel_words.pick_random()
		speechBubble.open()
		animations.play("run")
		
		get_tree().create_timer(4.0).timeout.connect(
			func():
				if speechBubble.isOpen:
					speechBubble.close()
				if active:
					animations.play("idle")
					#idleEffectTimer.start(randf_range(2,4))
		)
