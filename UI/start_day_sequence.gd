class_name StartSequence
extends Control

signal plsStartDay

const singleRule = preload("res://UI/components/single_rule.tscn")
const data = preload("res://resources/day1.tres")

@export var ruleList : VBoxContainer
@onready var tempRulesContainer: Control = $TempRules

@export var unnaturalhairtemplate : Sprite2D

var canAdvance = false


func playAnimation(withData: DayResource):
	if not TransitionAnimations.closed:
		TransitionAnimations.open()
		await TransitionAnimations.done
	populateRules(withData)
	$CarpeDiem.modulate.a = 0
	$CarpeDiem.show()
	$AnimationPlayer.play("start")
	await $AnimationPlayer.animation_finished
	rulesAnimation()


func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#playAnimation(data as DayResource)
	if event is InputEventKey or event is InputEventMouseButton:
		if event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_UP]:
			return
		if canAdvance and event.is_pressed():
			$AnimationPlayer.play_backwards("start")
			$CarpeDiem.modulate.a = 0
			$CarpeDiem.hide()
			plsStartDay.emit()
			await $AnimationPlayer.animation_finished
			TransitionAnimations.close()
			await TransitionAnimations.done
			canAdvance = false
		
		

func createSingleRule(traitOrAction, translationDict: Dictionary) -> HBoxContainer:
	var result = singleRule.instantiate()
	result.name = "SingleRule"
	
	var text := result.get_child(0) as RichTextLabel
	result.modulate.a = 0
	
	text.name = "RuleText"
	if translationDict.has(traitOrAction):
		text.text = "Do not " + translationDict.get(traitOrAction)
	else:
		push_error("Unkown trait or action pls add to translation list")
	
		text.text = "MISSINGO"
		
	return result

func rulesAnimation():
	for child in ruleList.get_children():
		
		var child2 = child.duplicate() as HBoxContainer
		
		tempRulesContainer.add_child(child2)
		child2.global_position = child.global_position
		child2.scale *= 8
		child2.modulate.a = 1
		
		var tween = child2.create_tween()
		tween.tween_property(child2, "scale", Vector2.ONE, .25)
		tween.set_ease(Tween.EASE_OUT)
		tween.finished.connect(
			func():
				child.modulate.a = 1
				child2.queue_free()
		)
		await get_tree().create_timer(.4).timeout
	
	canAdvance = true
	
	await get_tree().create_timer(.5).timeout
	var textTween = $CarpeDiem.create_tween()
	textTween.tween_property($CarpeDiem, "modulate:a", 1.0, 1)


func populateRules(dayData: DayResource):
	$RuleList/DayCount.text = "[color=black]MANIFESTO - DAY " + str(dayData.dayNumber)
	for child in ruleList.get_children():
		child.visible = false
		child.queue_free()
		
	for trt in dayData.disallowedTraits:
		var rule = createSingleRule(trt, PauseMenu.TRANSLATION_TRAITS)
		if trt == NPCTraitManager.TRAIT.NON_NATURAL_HAIR:
			
			var control1 = Control.new()
			var control2 = Control.new()
			
			var unnatural1 = unnaturalhairtemplate.duplicate()
			var unnatural2 = unnaturalhairtemplate.duplicate()
			unnatural2.frame_coords.x = 6
			
			control1.custom_minimum_size = Vector2(8,8)
			control2.custom_minimum_size = Vector2(8,8)
			
			control1.add_child(unnatural1)
			control2.add_child(unnatural2)
			
			unnatural1.show()
			unnatural2.show()
			
			rule.add_child(control1)
			rule.add_child(control2)
			
		ruleList.add_child(rule)
	
	for act in dayData.disallowedActions:
		var rule = createSingleRule(act, PauseMenu.TRANSLATION_STATES)
		ruleList.add_child(rule)
