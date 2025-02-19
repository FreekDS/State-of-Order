class_name NPCTraitManager
extends Node2D

@export var dikkeRonSprites : DikkeRonSprites

enum TRAIT {
	HOLDS_WEAPON,
	WEARS_YELLOW,
	IS_WOMEN,
	NON_NATURAL_HAIR,
}

var _traits : Array[TRAIT] = []


func addTrait(traitt: TRAIT):
	if _traits.has(traitt): return
	if traitt == TRAIT.WEARS_YELLOW:
		dikkeRonSprites.makeWearYellow()
	
	if traitt == TRAIT.IS_WOMEN:
		dikkeRonSprites.makeWomen()
		
	if traitt == TRAIT.NON_NATURAL_HAIR:
		dikkeRonSprites.giveUnNaturalHair()
	
	_traits.append(traitt)


func getTraits() -> Array[TRAIT]:
	return _traits
