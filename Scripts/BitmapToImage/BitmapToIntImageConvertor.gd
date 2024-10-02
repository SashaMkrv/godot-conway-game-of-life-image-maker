@tool
extends ImageConstructor

class_name BitmapToIntImageConvertor

## Create an image from an array of bitmaps. All bitmaps should be *at least* as big as the first.
func createImage(maps: Array[BitMap]) -> Image:
	print_debug(maps.size())
	var size = maps[0].get_size()
	print_debug(size)
	var image = Image.create(size.x, size.y, false, Image.FORMAT_RGB8)
	
	var color := Color.BLACK
	
	for x in size.x:
		for y in size.y:
			color = _getColorFromCoordinates(maps, palette, x, y)
			image.set_pixel(x, y, color)
	
	return image


func _getColorFromCoordinates(maps: Array[BitMap], palette: Array[Color], x: int, y: int) -> Color:
	if palette.is_empty():
		return Color.ALICE_BLUE
	
	var colorSelector = 0
	for map in maps:
		## stays 0 for first map, 1 max if only single map.
		colorSelector << 1
		if (map.get_bit(x, y)):
			colorSelector += 1
	
	return palette[colorSelector % palette.size()]
