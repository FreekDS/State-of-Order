extends Control

@onready var ruleList = $RuleList/MarginContainer/RuleList

const singleRule = preload("res://UI/components/single_rule.tscn")
@onready var animations: AnimationPlayer = $AnimationPlayer

var open = false

const TRANSLATION_STATES = {
	NPCStateManager.STATE.WANDER_AIMLESS: "walk around aimlessly",
	NPCStateManager.STATE.TALK_TO_SOMEONE: "talk to someone else",
	NPCStateManager.STATE.STANDSTILL: "stand still",
	NPCStateManager.STATE.LEAVING: "leave",
	NPCStateManager.STATE.INCOMING: "exist",
	NPCStateManager.STATE.SHOOT_SOMEONE: "shoot others",
	NPCStateManager.STATE.HIT_SOMEONE: "hit others",
	NPCStateManager.STATE.SMOKING: "smoke",
	NPCStateManager.STATE.WATCH_TV: "watch TV on the square",
	NPCStateManager.STATE.SWIM_IN_FONTAIN: "swim in the fountain",
	NPCStateManager.STATE.PROTEST: "protest",
	NPCStateManager.STATE.RUN: "run",
	NPCStateManager.STATE.USE_TRAIN: "use the train",
	

}

const TRANSLATION_TRAITS = {
	NPCTraitManager.TRAIT.HOLDS_WEAPON: "hold weapons",
	NPCTraitManager.TRAIT.WEARS_YELLOW: "wear yellow t-shirts",
	NPCTraitManager.TRAIT.IS_WOMEN: "be of the female kind",
	NPCTraitManager.TRAIT.NON_NATURAL_HAIR: "have unconventional hair",
}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if animations.is_playing():
			return
		if not open:
			get_tree().paused = true
			open = true
			show() # TODO: actual animation
			TransitionAnimations.open()
			await TransitionAnimations.done
			animations.play("show")
			
		else:
			animations.play_backwards("show")
			await animations.animation_finished
			TransitionAnimations.close()
			await TransitionAnimations.done
			get_tree().paused = false
			open = false
			hide()
		


func _ready() -> void:
	EventBus.dayStarted.connect(populateRules)


func createSingleRule(traitOrAction, translationDict: Dictionary) -> HBoxContainer:
	var result = singleRule.instantiate()
	result.name = "SingleRule"
	
	var text := result.get_child(0) as RichTextLabel
	
	text.name = "RuleText"
	if translationDict.has(traitOrAction):
		text.text = "Do not " + translationDict.get(traitOrAction)
	else:
		push_error("Unkown trait or action pls add to translation list")
	
		text.text = "MISSINGO"
		
	return result


func populateRules(dayData: DayResource):
	for child in ruleList.get_children():
		child.visible = false
		child.queue_free()
		
	for trt in dayData.disallowedTraits:
		ruleList.add_child(createSingleRule(trt, TRANSLATION_TRAITS))
	
	for act in dayData.disallowedActions:
		ruleList.add_child(createSingleRule(act, TRANSLATION_STATES))


func _on_settings_button_pressed() -> void:
	$Settings.show()


func _on_settings_close_request() -> void:
	$Settings.hide()
