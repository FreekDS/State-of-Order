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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.dayEnded.connect(_on_day_end)
	EventBus.dayStarted.connect(
		func(dayData: DayResource):
			day_summary.text = "Summary - Day " + str(dayData.dayNumber)
	)


func _on_day_end():
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
	var _canShowDaySummary := false
	var _canClose := false
	animations.play("RESET")


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("reset_camera"):
		reset()
		_on_day_end()
	
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_pressed():
			if _canShowDaySummary:
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
