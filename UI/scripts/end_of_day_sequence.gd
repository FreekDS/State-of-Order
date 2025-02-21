extends Control

signal done

@onready var CarpeDiem: RichTextLabel = $CarpeDiem
@onready var day_summary: RichTextLabel = %DaySummary

@onready var animations: AnimationPlayer = $AnimationPlayer

@onready var allArrestedText: RichTextLabel = %ArrestedCount
@onready var goodArrestedText: RichTextLabel = %GoodArrested
@onready var wrongArrestedText: RichTextLabel = %WrongArrested
@onready var socialCreditText: RichTextLabel = %SocialCreditcount

@onready var tempNodesContainer : Control = $TempNodes

var _canShowDaySummary := false
var _canClose := false



var guysCapturedToday = 0
var wrongGuysCapturedToday = 0
var rightGuysCapturedToday = 0

var totalSocialCredit = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.dayEnded.connect(_on_day_end)
	EventBus.dayStarted.connect(
		func(dayData: DayResource):
			day_summary.text = "Summary - Day " + str(dayData.dayNumber)
	)
	
	EventBus.successfulCapture.connect(
		func(_guy, _amount):
			guysCapturedToday += 1
			rightGuysCapturedToday += 1
			totalSocialCredit += 1
	)
	EventBus.wrongCapture.connect(
		func(_guy, _amount): 
			guysCapturedToday += 1
			wrongGuysCapturedToday += 1
			totalSocialCredit -= 1
			if totalSocialCredit < 0: totalSocialCredit = 0
	)

func setupTexts():
	allArrestedText.text = "Total people arrested: [indent]" + str(guysCapturedToday)
	goodArrestedText.text = "Rightful arrestations:[indent]" + str(rightGuysCapturedToday)
	wrongArrestedText.text = "Unfortunate collateral convictions: [indent]" + str(wrongGuysCapturedToday)
	socialCreditText.text = "Social credit at end of day: [indent]" + str(totalSocialCredit)


func _on_day_end():
	setupTexts()
	var textTween = CarpeDiem.create_tween()
	textTween.tween_property(CarpeDiem, "modulate:a", 1.0, 1)
	await textTween.finished
	_canShowDaySummary = true


func playTextAnimations():
	var toAnimate = [allArrestedText, goodArrestedText, wrongArrestedText, socialCreditText]
	for child in toAnimate:
		
		var child2 = child.duplicate() as RichTextLabel
		
		tempNodesContainer.add_child(child2)
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
	
	animations.play("continueText")
	_canClose = true
	


func reset():
	var toAnimate = [allArrestedText, goodArrestedText, wrongArrestedText, socialCreditText]
	for text in toAnimate:
		text.modulate.a = 0

	_canShowDaySummary = false
	_canClose = false
	animations.play("RESET")
	guysCapturedToday = 0
	wrongGuysCapturedToday = 0
	rightGuysCapturedToday = 0


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("reset_camera"):
		reset()
		_on_day_end()
	
	if event is InputEventKey or event is InputEventMouseButton:
		if event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_WHEEL_DOWN, MOUSE_BUTTON_WHEEL_UP]:
			return
		if event.is_pressed():
			if _canShowDaySummary:
				if not TransitionAnimations.closed:
					TransitionAnimations.open()
					await TransitionAnimations.done
				_canShowDaySummary = false
				CarpeDiem.modulate.a = 0
				animations.play("show")
				await animations.animation_finished
				playTextAnimations()
				return
			if _canClose:
				animations.play_backwards("show")
				_canClose = false
				await animations.animation_finished
				done.emit()
				reset()
				return
