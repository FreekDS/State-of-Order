extends Sprite2D


const HAIR_ROW = 0
const FACE_ROW_NORMAL = 1
const FACE_ROW_SCARED = 2
const SHIRT_ROW = 3
const PANTS_ROW = 4

const WOMEN_SHORTS = [
	6,7,8,9
]

# Faces that can only be used for male characters
const ONLY_MALE_FACES = [
	7
]

const YELLOW_SHIRT = 4

@onready var hair: Sprite2D = $Hair
@onready var face: Sprite2D = $Face
@onready var shirt: Sprite2D = $Shirt
@onready var pants: Sprite2D = $Pants

@onready var _sprites : Array[Sprite2D] = [
	self, hair, face, shirt, pants
]

var isWomen = false

func faceRight():
	for sprite: Sprite2D in _sprites:
		sprite.flip_h = false
		
func faceLeft():
	# not to be confused with facelift
	for sprite: Sprite2D in _sprites:
		sprite.flip_h = true

func updatOffset(newOffset: Vector2):
	for sprite: Sprite2D in _sprites:
		sprite.offset = newOffset

func randomOutfit():
	hair.frame_coords.y = HAIR_ROW
	hair.frame_coords.x = randi_range(0, hair.hframes-1)
	
	face.frame_coords.y = FACE_ROW_NORMAL
	face.frame_coords.x = randi_range(0, face.hframes-1)
	
	shirt.frame_coords.y = SHIRT_ROW
	shirt.frame_coords.x = randi_range(0, shirt.hframes-1)

	pants.frame_coords.y = PANTS_ROW
	pants.frame_coords.x = randi_range(0, pants.hframes-1)


func makeWomen():
	randomOutfit()
	isWomen = true
	pants.frame_coords.x = WOMEN_SHORTS.pick_random()
	
	while face.frame_coords.x in ONLY_MALE_FACES:
		face.frame_coords.x = randi_range(0, face.hframes-1)
	

func makeMen():
	randomOutfit()
	
	while pants.frame_coords.x in WOMEN_SHORTS:
		pants.frame_coords.x = randi_range(0, pants.hframes-1)


func makeWearYellow():
	shirt.frame_coords.x = YELLOW_SHIRT


func wearsYellow() -> bool:
	return shirt.frame_coords.x == YELLOW_SHIRT

func _ready() -> void:
	randomOutfit()

func setScared(scared: bool):
	if scared:
		face.frame_coords.y = FACE_ROW_SCARED
	else:
		face.frame_coords.y = FACE_ROW_NORMAL


func isScared() -> bool:
	return face.frame_coords.y == FACE_ROW_SCARED

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#randomOutfit()
