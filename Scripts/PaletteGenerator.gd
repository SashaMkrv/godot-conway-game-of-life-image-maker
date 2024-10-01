extends Node

func requestPalette(size: int, rng: RandomNumberGenerator) -> Array[Color]:
	var colors: Array[Color] = []
	for color in size:
		colors.append(generateColor(rng))
	
	return colors


func generateColor(rng: RandomNumberGenerator) -> Color:
	return Color(
		rng.randf(),
		rng.randf(),
		rng.randf(),
		rng.randf()
	)
