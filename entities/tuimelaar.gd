extends CharacterBody2D

@onready var anim = $Rolling
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity=Vector2(randf_range(30,100),0)
	anim.play("Rolling_in_the_deep")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_slide()
