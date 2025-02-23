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

func obtainTraitsFromSprites():
	if dikkeRonSprites.wearsYellow():
		if not _traits.has(TRAIT.WEARS_YELLOW):
			_traits.append(TRAIT.WEARS_YELLOW)
	if dikkeRonSprites.hasUnnaturalHair():
		if not _traits.has(TRAIT.NON_NATURAL_HAIR):
			_traits.append(TRAIT.NON_NATURAL_HAIR)
	if dikkeRonSprites.isWomen:
		if not _traits.has(TRAIT.IS_WOMEN):
			_traits.append(TRAIT.IS_WOMEN)


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
