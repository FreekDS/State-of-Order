class_name PanArrowVisualizer
extends Control

@export var disabledColor : Color = Color("0000003e")
@export var highlightColor : Color = Color.WHITE

@onready var left: TextureRect = $left
@onready var top: TextureRect = $top
@onready var right: TextureRect = $right
@onready var bot: TextureRect = $bot

var _originalModulate : Color

func _ready() -> void:
	_originalModulate = left.modulate
	
@onready var edgeToRectMap = {
	Vector2i.LEFT: $left,
	Vector2i.RIGHT: $right,
	Vector2i.UP: $top,
	Vector2i.DOWN: $bot
}

func disableEdge(edge: Vector2i) -> void:
	if not edgeToRectMap.has(edge): return
	edgeToRectMap[edge].modulate = disabledColor


func restoreEdges() -> void:
	for edge in edgeToRectMap.keys():
		edgeToRectMap[edge].modulate = _originalModulate


func restoreEdgeColor(edge: Vector2i) -> void:
	if not edgeToRectMap.has(edge): return
	edgeToRectMap[edge].modulate = _originalModulate


func highlightEdge(edge: Vector2i) -> void:
	if not edgeToRectMap.has(edge): return
	edgeToRectMap[edge].modulate = highlightColor
