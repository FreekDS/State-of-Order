extends Node

# Nen singleton 🤮 maja het werkt wel

var allNpcs : Array[DikkeRon] = []

func aliveNPCCount():
	var deadOnes : Array = allNpcs.filter(
		func(npc):
			if npc == null:
				return false
			if npc.is_queued_for_deletion():
				return false
			return npc.stateManager._stateType == NPCStateManager.STATE.DEAD
	)
	return allNpcs.size() - deadOnes.size()

var fountainPosition : Vector2 = Vector2.ZERO

var dayIsActive = false


var playedTutorial = false
