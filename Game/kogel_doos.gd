extends Node2D
@export var kogelScene:PackedScene

func _ready() -> void:
	EventBus.kogelHier.connect(kogel)

func kogel(pos,vec)->void:
	var newkogel=kogelScene.instantiate()
	add_child(newkogel)
	newkogel.position=pos
	newkogel.schiet(vec)
