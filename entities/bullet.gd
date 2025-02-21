extends CharacterBody2D
@onready var timer:Timer=$ActiveTimer

var active:bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !active:
		return
	if body is DikkeRon:
		if body.stateManager._stateType==NPCStateManager.STATE.DEAD:
			return
		body.beKilled()
		self.queue_free()

func schiet(vel: Vector2):
	timer.start()
	velocity=vel*360

func _process(_delta: float) -> void:
	if velocity.x < 0:
		faceLeft()
	if velocity.x > 0:
		faceRight()
		
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func _on_timer_timeout() -> void:
	active=true
	
func faceRight():
	$Bullet.flip_h = false
		
func faceLeft():
	$Bullet.flip_h = true
