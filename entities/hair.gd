extends Node2D

@export var dikkeRon:DikkeRon
@export var sprite:Sprite2D
@export var highlight: Sprite2D
@export var speechBubble:Sprite2D
@export var geweer:Sprite2D
@export var bouncyness:float

@onready
var nodesToOffset : Array[Sprite2D] = [sprite, highlight, speechBubble, geweer]

# wanted offset, max distance, actual pos, radius
var points = [
	[Vector2(0,-1),10,Vector2(0,0),5],
	[Vector2(0,0),10,Vector2(0,0),5],
	[Vector2(0,2),2,Vector2(0,0),4],
	[Vector2(0,4),2,Vector2(0,0),2],
	#[Vector2(0,3),2,Vector2(0,0),3],
	]
var prevpos:Vector2=Vector2(0,0)

var DragMode : bool = false

var color : Color = Color.RED

var spriteLocBeforeMove : Vector2= Vector2(0,0)

func _ready() -> void:
	#performance ding want dit kan traag zijn als ge het veel runned
	set_physics_process(false)
	

func _physics_process(delta: float) -> void:
	if( not DragMode):
		updatePointsNormal(delta)
	else:
		updatePointsNormal(delta)
		applyOffset(points.back()[2]+Vector2(0,-10))
	queue_redraw()
	
func updatePointsNormal(_delta) -> void:
	var dif = prevpos-dikkeRon.global_position
	prevpos=dikkeRon.global_position
	
	for i in points:
		i[2]+=dif
		
	for i in range(len(points)-1,-1,-1):
		if i==0:
			points[i][2]=Vector2(0,0)
			continue
		points[i][2]=(points[i][0]+points[i][2]+points[i-1][2])/bouncyness
		
	for i in range(len(points)):
		if i == 0:
			continue
		if points[i][2].distance_to(points[i][0]+points[i-1][2])> points[i][1]:
			var dir = (points[i-1][2]+points[i][0]).direction_to(points[i][2])
			var offset = dir * points[i][1]
			points[i][2]=points[i-1][2]+offset+points[i][0]
			
func updatePointsDrag() -> void:
	pass
	
func _draw() -> void:
	for i in range(len(points)):
		if DragMode and i==len(points):
			continue
		var point=points[i]
		draw_circle(point[2],point[3],color)
	
func EnableDragmode() -> void:
	
	show()
	if DragMode:
		return
	set_physics_process(true)
	spriteLocBeforeMove=sprite.offset
	#reverse of the points + extra last one indicating the user
	points.reverse()
	#points.append([points.back()[0],points.back()[1],points.back()[2],-2])
	DragMode = true
	
func DisableDragmode() -> void:
	hide()
	if not DragMode:
		return
	applyOffset(spriteLocBeforeMove)
	#performance ding want dit kan traag zijn als ge het veel runned
	set_physics_process(false)
	DragMode = false
	#points.remove_at(len(points)-1)
	points.reverse()
	geweer.offset=Vector2(0,0)
	

func applyOffset(newOffset):
	for spr in nodesToOffset:
		if spr == null:
			continue
		
		if spr is SpeechBubble:
			spr.position = newOffset + Vector2(0, -19) # size of speechbubble
		elif spr is DikkeRonSprites:
			spr.updatOffset(newOffset)
		else:
			spr.offset = newOffset
