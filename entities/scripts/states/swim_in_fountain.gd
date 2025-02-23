extends NPCState

@onready var fountainDetector: Area2D = $FountainDetector
@onready var splash: GPUParticles2D = $Splash
@onready var swim_time: Timer = $SwimTime

@export var speed = 30
@export var swimSpeed = 5

@export var maxSwimTime = 5
@export var minSwimTime = 2

enum SubStates {
	MOVE_TOWARDS_FOUNTAIN,
	JUMP_IN,
	JUMP_OUT,
	SWIM,
	SPREAD_OUT,
}

var _substate := SubStates.MOVE_TOWARDS_FOUNTAIN
var _detectedFountain : StaticBody2D = null
var targetPoint : Vector2 = Vector2.ZERO


var _fountainEnterPoint := Vector2.ZERO

var exiting = false

class CurveProgress:
	var startPoint : Vector2
	var heightPoint : Vector2
	var endPoint : Vector2
	
	var t : float
	
	func get_quadratic() -> Vector2:
		var q0 = startPoint.lerp(heightPoint, t)
		var q1 = heightPoint.lerp(endPoint, t)
		
		var r = q0.lerp(q1, t)
		return r


var _curveProgress : CurveProgress = null

func _ready() -> void:
	possibleNextStates = [
		NPCStateManager.STATE.WANDER_AIMLESS,
		NPCStateManager.STATE.PROTEST,
	]
	nextStatesWeigths=[
		10,
		2
	]
	
func enter():
	debug.text = "SWIM (move)"
	animations.play("run")
	fountainDetector.monitoring = true
	fountainDetector.visible = true
	exiting = false
	_substate = SubStates.MOVE_TOWARDS_FOUNTAIN
	navAgent.target_position = Globals.fountainPosition

func tick(delta: float):
	if exiting:
		return
	match _substate:
		SubStates.MOVE_TOWARDS_FOUNTAIN:
			_moveToFountain()
		SubStates.JUMP_IN:
			_jump(delta)
		SubStates.SWIM:
			_swim()
		SubStates.JUMP_OUT:
			_jump(delta)
		SubStates.SPREAD_OUT:
			var direction = (navAgent.target_position - character.global_position).normalized() * 50
			character.velocity = direction
			
			if navAgent.target_position.distance_to(character.global_position) < 10:
				exiting = true
				await get_tree().create_timer(.5).timeout
				switchState.emit(self)
		

func _moveToFountain():
	if navAgent.is_navigation_finished():
		navAgent.target_position = Globals.fountainPosition
	
	targetPoint = navAgent.get_next_path_position()
	
	var direction = (targetPoint - character.global_position).normalized() * speed
	character.velocity = direction


func _jump(delta: float):
	character.velocity = Vector2.ZERO
	
	if _curveProgress != null:
		
		if _curveProgress.endPoint.x < _curveProgress.startPoint.x:
			character.sprite.look_at(_curveProgress.get_quadratic())
		else:
			character.sprite.look_at(-_curveProgress.get_quadratic())
			
		character.global_position = _curveProgress.get_quadratic()
		_curveProgress.t += delta
		
		if _curveProgress.t >= 1:
			if _substate == SubStates.JUMP_IN:
				Audio.splash(character.global_position)
				_substate = SubStates.SWIM
				splash.emitting = true
				_curveProgress = null
				debug.text = "SWIM"
				animations.play("idle")
				targetPoint = _pickPointInFountain()
				character.sprite.rotation_degrees = 0
				character.sprite.showFaceOnly(true)
				swim_time.start(
					randf_range(minSwimTime, maxSwimTime)
				)
			elif _substate == SubStates.JUMP_OUT:
				animations.play("run")
				debug.text = "SWIM (spread)"
				character.sprite.rotation_degrees = 0
				_substate = SubStates.SPREAD_OUT
				navAgent.target_position = NavigationServer2D.map_get_random_point(navAgent.get_navigation_map(), 1, true)


func _swim():
	
	if character.global_position.distance_to(targetPoint) < 10:
		targetPoint = _pickPointInFountain()
	
	var direction = (targetPoint - character.global_position).normalized() * swimSpeed
	character.velocity = direction


func _pickPointInFountain() -> Vector2:
	if _detectedFountain == null:
		push_error("Vreemd, zou ni mogen geberuenr")
		return Vector2.ZERO
		
	var pos := _detectedFountain.global_position + Vector2(0, 5)
	const X_EXT = 30
	const Y_EXT = 20
	
	var x = randf_range(pos.x - X_EXT, pos.x + X_EXT)
	var y = randf_range(pos.y-Y_EXT, pos.y) - character.sprite.offset.y
	
	return Vector2(x, y)


func exit():
	fountainDetector.monitoring = false
	fountainDetector.visible = false
	_detectedFountain = null
	_curveProgress = null
	character.collision.set_deferred("disabled", false)
	character.sprite.rotation_degrees = 0
	character.sprite.showFaceOnly(false)


func _on_fountain_detector_body_entered(body: Node2D) -> void:
	if _substate == SubStates.MOVE_TOWARDS_FOUNTAIN:
		if body is StaticBody2D and body.name == "Fountain":
			character.collision.set_deferred("disabled", true)
			debug.text = "SWIM (jump)"
			_fountainEnterPoint = character.global_position
			_detectedFountain = body
			_substate = SubStates.JUMP_IN
			
			animations.stop()
			await get_tree().create_timer(1).timeout
			
			_curveProgress = CurveProgress.new()
			_curveProgress.startPoint = character.global_position
			_curveProgress.endPoint = _pickPointInFountain()
			_curveProgress.heightPoint = (
				(_curveProgress.endPoint - _curveProgress.startPoint) / 2 - Vector2(0,200)
			)
			
			
func onDrag():
	character.collision.set_deferred("disabled", false)
	character.sprite.rotation_degrees = 0
	character.sprite.showFaceOnly(false)


func onDragEnd():
	if character.dead:
		return
	switchState.emit(self)


func isMainActionBusy() -> bool:
	return _substate == SubStates.SWIM


func _on_swim_time_timeout() -> void:
	_substate = SubStates.JUMP_OUT
	debug.text = "SWIM (jump2)"
	animations.stop()
	splash.emitting = true
	character.velocity = Vector2.ZERO
	character.sprite.showFaceOnly(false)
	
	_curveProgress = CurveProgress.new()
	_curveProgress.startPoint = character.global_position
	_curveProgress.endPoint = _fountainEnterPoint
	_curveProgress.heightPoint = (
		(_curveProgress.endPoint - _curveProgress.startPoint) / 2 - Vector2(0,200)
	)
