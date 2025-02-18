class_name SpeechBubble
extends Sprite2D


const options : Dictionary = {
	"scared": "[shake]😨"
}

#@export_enum(
	#"[shake]😠",
	#"...",
	#"♥",
	#"🙂",
	#"💲",
	#"💤",
	#"🐱‍🐉",
	#"[shake]😨"
@export var option : String = "[shake]😠"

@onready var label: RichTextLabel = $RichTextLabel
@onready var animations: AnimationPlayer = $AnimationPlayer

var isOpen := false

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("pan_camera_down"):
		#open()
	#if event.is_action("pan_camera_up"):
		#close()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "\n" + option

func open():
	label.text = "\n" + option
	if not isOpen:
		animations.play("show", -1, 4)
	isOpen = true
	
	
func close():
	isOpen = false
	animations.play("show", -1, -4, true)
