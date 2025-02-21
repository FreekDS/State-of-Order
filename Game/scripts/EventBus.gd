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

@warning_ignore("unused_signal")
signal daySetup(dayData: DayResource)
@warning_ignore("unused_signal")
signal dayStarted(dayData: DayResource)

@warning_ignore("unused_signal")
signal dayEnded

#jaja kan een enum worden, maar ik ben lui
@warning_ignore("unused_signal")
signal changeCursor(normaal: bool)


@warning_ignore("unused_signal")
signal kogelHier(positie: Vector2, velocity: Vector2)
