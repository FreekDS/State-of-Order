class_name NPCTraitManager
extends Node2D


enum TRAIT {
	HOLDS_WEAPON,
	WEARS_YELLOW,
	IS_WOMEN,
	NON_NATURAL_HAIR,
}

var _traits : Array[TRAIT] = []


func getTraits() -> Array[TRAIT]:
	return _traits
