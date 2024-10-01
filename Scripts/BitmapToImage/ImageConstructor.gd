@tool
extends Node
## Base class for bit maps -> image conversion. Returns an empty image. Takes every variable conceivable. This makes me sad.
class_name ImageConstructor

## Palette to choose image colours from. If there aren't enough colours, the constructor will modulo through.
##
## If there are zero colours, I will cry. If there is one colour, you will cry.
@export
var palette: Array[Color] = [Color.BLACK, Color.REBECCA_PURPLE, Color.YELLOW_GREEN, Color.YELLOW, Color.WHITE]


## Create an image from an array of bitmaps. All bitmaps should be *at least* as big as the first.
func createImage(maps: Array[BitMap]) -> Image:
	# maybe the other combinations should be handled in filter/effect nodes???
	var size = maps[0].get_size()
	var image = Image.create(size.x, size.y, false, Image.FORMAT_RGB8)
	
	return image
