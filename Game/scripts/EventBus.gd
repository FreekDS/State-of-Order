extends Node


@warning_ignore("unused_signal")
signal guyCaptured(who: DikkeRon)

@warning_ignore("unused_signal")
signal timeUpdated(hour: int)

@warning_ignore("unused_signal")
signal timesUp

@warning_ignore("unused_signal")
signal successfulCapture(who: DikkeRon, score: int)

@warning_ignore("unused_signal")
signal wrongCapture(who: DikkeRon, score: int)
