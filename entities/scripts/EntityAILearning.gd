class_name DikkeRon
extends CharacterBody2D

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var highlight: Sprite2D = $Sprite2D/Highlight
@onready var sprite: Sprite2D = $Sprite2D

@onready var hair: Node2D = $Sprite2D/Hair
@onready var stateManager: NPCStateManager = $StateManager

var selected := false
var pickable := true
var pickedUp := false

signal helpIkBenGeselecteerd(who: DikkeRon)
signal neverMindIkBenGedeselect(who: DikkeRon)

var dead = false

func _ready():
	animations.play("run", -1, 1.1)


func setup(navigationMap: RID):
	stateManager.navigationMap = navigationMap


func isMouseInDaHouse():
	var mousePos := get_local_mouse_position()
	return sprite.get_rect().has_point(mousePos) and pickable


func _physics_process(_delta: float) -> void:
	if isMouseInDaHouse():
		highlight.show()
		helpIkBenGeselecteerd.emit(self)
		selected = true
	elif not pickedUp:
		highlight.hide()
		neverMindIkBenGedeselect.emit(self)
		

	move_and_slide()
	
func startDrag() -> void:
	set_collision_layer_value(2, true)	# Interact with police
	set_collision_layer_value(1, false)	# no longer interact with others
	
	set_collision_mask_value(1, false)

	hair.EnableDragmode()
	pickedUp=true
	$AnimationPlayer.play("RESET")
	
func endDrag() -> void:
	set_collision_layer_value(2, false)	# no longer interact with police
	set_collision_layer_value(1, true)	# interact with others again
	
	set_collision_mask_value(1, true)
	hair.DisableDragmode()
	pickedUp=false
	if not dead:
		animations.play("run")


func die():
	dead = true
	animations.animation_finished.connect(
		func(_anim): queue_free(), CONNECT_ONE_SHOT
	)
	animations.play("die", -1, 1.5)
	
	
