class_name DikkeRon
extends CharacterBody2D


@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D

@onready var sprite: Sprite2D = $Sprite2D

var selected := false

signal helpIkBenGeselecteerd(who: DikkeRon)
signal neverMindIkBenGedeselect(who: DikkeRon)


func _ready():
	animations.play("run", -1, 1.1)



func isMouseInDaHouse():
	var mousePos := get_local_mouse_position()
	return sprite.get_rect().has_point(mousePos)


func _physics_process(delta: float) -> void:
	if isMouseInDaHouse():
		$Sprite2D/ColorRect.show()
		helpIkBenGeselecteerd.emit(self)
		selected = true
	else:
		$Sprite2D/ColorRect.hide()
		neverMindIkBenGedeselect.emit(self)
		selected = false
		
	velocity.x = -20
	move_and_slide()
	
func startDrag() -> void:
	$CollisionShape2D.disabled = true
	
func endDrag() -> void:
	$CollisionShape2D.disabled = false


func die():
	animations.animation_finished.connect(
		func(_anim): queue_free(), CONNECT_ONE_SHOT
	)
	animations.play("die", -1, 1.5)
	
