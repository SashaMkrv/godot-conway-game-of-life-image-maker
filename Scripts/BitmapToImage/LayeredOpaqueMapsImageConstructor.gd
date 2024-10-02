@tool
extends ImageConstructor
class_name LayeredOpaqueMapsImageConstructor

## Create image from bitmaps. Uses first palette color for dead cells, and one other colour per bitmap for live cells.
func createImage(maps: Array[BitMap]) -> Image:
	var size := maps[0].get_size()
	var image := Image.create_empty(size.x, size.y, false, Image.FORMAT_RGB8)
	image.fill(Color.TRANSPARENT)
	
	var opacity:= 0.50
	var newColor := Color.TRANSPARENT
	var currentColor := Color.TRANSPARENT
	var map: BitMap
	
	for x in size.x:
		for y in size.y:
			
			currentColor = palette[0]
			
			for mapIndex in maps.size():
				
				map = maps[mapIndex]
				
				if _coordinatesAlive(map, x, y):
					newColor = _colorForIndex(mapIndex, palette)
					newColor.a = opacity
					currentColor = currentColor.blend(newColor)
				else:
					pass
			
			image.set_pixel(x, y, currentColor)
	
	return image

func _coordinatesAlive(map: BitMap, x: int, y: int) -> bool:
	return map.get_bit(x, y)

func _colorForIndex(index: int, palette: Array[Color]) -> Color:
	if palette.size() == 1:
		return palette[0]
	# ignore first colour (since that's the base) by shrinking palette size by one and shifting the resulting index by one
	var colorIndex = 1 + (index % (palette.size() - 1))
	return palette[colorIndex]
