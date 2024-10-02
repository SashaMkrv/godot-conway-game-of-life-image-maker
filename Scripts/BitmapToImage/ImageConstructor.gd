@tool
extends Node
## Base class for bit maps -> image conversion. Returns an empty image. Contains every member var conceivable. This makes me sad.
class_name ImageConstructor

## Palette to choose image colours from. If there aren't enough colours, image constructors will modulo through.
##
## If there are zero colours, I will cry. If there is one colour, you will cry.
@export
var palette: Array[Color] = [Color.BLACK, Color.REBECCA_PURPLE, Color.YELLOW_GREEN, Color.YELLOW, Color.WHITE]


## Create an image from an array of bitmaps. All bitmaps should be *at least* as big as the first.
func createImage(maps: Array[BitMap]) -> Image:
	var size = maps[0].get_size()
	var image = Image.create(size.x, size.y, false, Image.FORMAT_RGB8)
	
	return image
