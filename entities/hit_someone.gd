extends NPCState

@export var detectOthers : Area2D

@export var speechBubble : SpeechBubble
@export var vuistSprite= Sprite2D

@onready var fightLengthTimer : Timer = $FightLengthTimer
#tbf deze timer is niet nodig, kan ook gewoon constant boven onze ron hangen
@onready var talkBubbleTimer : Timer = $TalkBubbleTimer
@onready var hitTimer : Timer = $HitTimer
@onready var hitanimation: AnimationPlayer=$HitAnimationPlayer

@export var minFightTime = 5
@export var maxFightTime = 10

var neighbourchosen : DikkeRon
var boos_words = [
	"rage",
]
var active = false

var animToPlay:String=""
func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.STANDSTILL, 
		NPCStateManager.STATE.WANDER_AIMLESS,
		#NPCStateManager.STATE.HIT_SOMEONE, #twe keer vecht? pakt van niet
		NPCStateManager.STATE.TALK_TO_SOMEONE,
		NPCStateManager.STATE.HODL_GUN
	]
#wandelen naar de neighbour niet nodig, want na het praten staat ge er al naast normaal
func enter():
	if neighbourchosen:
		debug.text = "VECHTEN initiate"
		neighbourchosen.stateManager.enforceState(NPCStateManager.STATE.HIT_SOMEONE)
		fightLengthTimer.start(randf_range(minFightTime, maxFightTime))
		
	else:
		#ge hebt hier wel uwen buur nodig
		debug.text = "VECHTEN follow"
		var buren = detectOthers.burenGraag()
		for buur in buren:
			if NPCStateManager.STATE.HIT_SOMEONE == buur.stateManager._stateType:
				neighbourchosen = buur
				break
		
		fightLengthTimer.start(maxFightTime)	
	
	# ik snap het echt niet, maar dit is mogelijk 
	if neighbourchosen != null:	
		vuistSprite.rotation=180+neighbourchosen.global_position.angle_to_point(self.character.global_position)
		hitanimation.play("hit")
		talkBubbleTimer.start(randf_range(1,2))
		active = true
		speechBubble.option = boos_words.pick_random()
		speechBubble.open()
	else:
		print("meneer wilt vechten met de wind, pakt van niet")
		switchState.emit(self)

func tick(_delta: float):
	character.velocity = Vector2.ZERO
	if neighbourchosen == null:
		switchState.emit(self)
	if neighbourchosen != null:
		vuistSprite.rotation=180+neighbourchosen.global_position.angle_to_point(self.character.global_position)

func exit():
	hitanimation.play("RESET")
	neighbourchosen=null
	active = false
	talkBubbleTimer.stop()
	hitTimer.stop()
	fightLengthTimer.stop()
	if speechBubble.isOpen:
		speechBubble.close()

func checkViable() -> bool:
	var buren = detectOthers.burenGraag()
	for buur in buren:
		#Als ge deze check afzet kunt ge met iemand willekeurig in de buurt beginnen vechten, wat wel grappig zou zijn tbf
		if NPCStateManager.STATE.HIT_SOMEONE in buur.stateManager.getViableNextStates():
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


func _on_fight_length_timer_timeout() -> void:
	if not active:
		return
	if neighbourchosen:
		neighbourchosen.stateManager.enforceNextState()
	switchState.emit(self)


func _on_hit_timer_timeout() -> void:
	if not active:
		return
	hitanimation.play("hit")


func _on_hit_animation_player_animation_finished(_anim_name: StringName) -> void:
	if not active:
		return
	hitTimer.start(randf_range(0,1))
