extends Sprite2D

@export_enum(
	"[shake]😠",
	"...",
	"♥",
	"🙂",
	"💲",
	"😨"
) var option : String = "[shake]😠"

@onready var label: RichTextLabel = $RichTextLabel
@onready var animations: AnimationPlayer = $AnimationPlayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pan_camera_down"):
		open()
	if event.is_action("pan_camera_up"):
		close()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = "\n" + option

func open():
	animations.play("show", -1, 4)
	
func close():
	animations.play("show", -1, -4, true)
