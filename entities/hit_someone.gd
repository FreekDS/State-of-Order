extends NPCState

@export var detectOthers : Area2D

@export var speechBubble : SpeechBubble

@export var minTalkTime = 5
@export var maxTalkTime = 10

var neighbourchosen : DikkeRon
var boos_words = [
	"😡",
]
var active = false
func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.HIT_SOMEONE,
		#NPCStateManager.STATE.TALK_TO_SOMEONE
	]
#eerst wandelen naar de neighbour, en dan slaan -> neihbour ook boos en beignt ook te slaan
func enter():
	if neighbourchosen:
		debug.text = "VECHTEN initiate"
		neighbourchosen.stateManager.enforceState(NPCStateManager.STATE.HIT_SOMEONE)
	else:
		debug.text = "VECHTEN follow"
			
	
	
	active = true
	speechBubble.option = boos_words.pick_random()
	speechBubble.open()

func tick():
	character.velocity = Vector2.ZERO

func exit():
	neighbourchosen=null
	active = false
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

func _on_talk_bubble_timer_timeout() -> void:
	if speechBubble != null:
		speechBubble.option = boos_words.pick_random()
		speechBubble.open()
		
		get_tree().create_timer(4.0).timeout.connect(
			func():
				if speechBubble.isOpen:
					speechBubble.close()
				if active:
					pass
					#idleEffectTimer.start(randf_range(2,4))
		)
