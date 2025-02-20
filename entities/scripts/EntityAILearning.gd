class_name DikkeRon
extends CharacterBody2D

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var highlight: Sprite2D = $DikkeRonSprites/Highlight
@onready var sprite: DikkeRonSprites = $DikkeRonSprites

@onready var hair: Node2D = $DikkeRonSprites/Hair
@onready var stateManager: NPCStateManager = $StateManager
@onready var traitManager: NPCTraitManager = $TraitManager
@onready var speechbubble: SpeechBubble = $Speechbubble

var selected := false
var pickable := true
var pickedUp := false

signal helpIkBenGeselecteerd(who: DikkeRon)
signal neverMindIkBenGedeselect(who: DikkeRon)

signal dragEnded
signal dragStarted

var dead = false

func _ready():
	animations.play("run", -1, 1.1)
	hair.color = sprite.getHairColor()


func setup(navigationMap: RID):
	stateManager.navigationMap = navigationMap


func isMouseInDaHouse():
	var mousePos := get_local_mouse_position()
	return sprite.get_rect().has_point(mousePos) and pickable

func _process(_delta: float) -> void:
	if velocity.x < 0:
		sprite.faceLeft()
	if velocity.x > 0:
		sprite.faceRight()

func _physics_process(_delta: float) -> void:
	if isMouseInDaHouse() and not dead:
		highlight.show()
		helpIkBenGeselecteerd.emit(self)
		selected = true
	elif not pickedUp:
		highlight.hide()
		neverMindIkBenGedeselect.emit(self)
		
	if dead: velocity = Vector2.ZERO
	move_and_slide()
	
func startDrag() -> void:
	set_collision_layer_value(2, true)	# Interact with police
	set_collision_layer_value(1, false)	# no longer interact with others
	
	set_collision_mask_value(1, false)
	
	speechbubble.option = "😨"
	speechbubble.open()
	
	dragStarted.emit()
	stateManager.process_mode = Node.PROCESS_MODE_DISABLED
	
	hair.EnableDragmode()
	pickedUp=true
	animations.play("run", -1, 5.0)
	


func endDrag() -> void:
	set_collision_layer_value(2, false)	# no longer interact with police
	set_collision_layer_value(1, true)	# interact with others again
	
	set_collision_mask_value(1, true)
	hair.DisableDragmode()
	
	stateManager.process_mode = Node.PROCESS_MODE_INHERIT
	dragEnded.emit()
	
	speechbubble.close()
	
	pickedUp=false
	if not dead:
		animations.play("run")
		
		# Check if we dropped in the navigation map, if not, move character back in
		var closestMapPoint = NavigationServer2D.map_get_closest_point(stateManager.navigationMap, global_position)
		if not closestMapPoint.is_equal_approx(global_position):
			set_physics_process(false)
			
			var direction = (closestMapPoint - global_position).normalized()
			
			var tween := create_tween()
			tween.tween_property(
				self, "global_position", closestMapPoint + direction * 30, 1.0
			)
			tween.finished.connect(func(): 
				set_physics_process(true)
				stateManager.recalculateRoute()
			)
			tween.play()


func die():
	dead = true
	animations.play("die", -1, 1.5)
	animations.animation_finished.connect(
		func(_anim): queue_free(), CONNECT_ONE_SHOT
	)

func obtainTraits() -> Array[NPCTraitManager.TRAIT]:
	return traitManager.getTraits()


func obtainCurrentStates() -> Array[NPCStateManager.STATE]:
	return stateManager.getStates()
