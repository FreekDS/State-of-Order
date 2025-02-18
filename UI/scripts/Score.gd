extends RichPopText

var _score := 0

var _targetColor := Color.WHITE

func setPositive():
	_targetColor = Color.WEB_GREEN

func setNegative():
	_targetColor = Color.DARK_RED


func updateScore(amount: int):
	if amount < 0: setNegative()
	else: setPositive()
	if _score + amount < 0:
		doPop()
		return
	_score += amount
	_score = clamp(_score, 0, INF)
	text = str(_score).lpad(4, '0')
	doPop()


func doPop() -> Tween:
	modulate = _targetColor
	var baseTween := super.doPop()
	baseTween.tween_property(self, "modulate", Color.WHITE, shrinkDuration)
	return baseTween
