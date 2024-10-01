@tool
extends Node

@onready
var imageNode: TextureRect = $TextureRect
@onready
var game = $ConwayGame

var isReady:= false
var waitingToRender:= false
var pendingBitMap: BitMap

var _imageTexture: ImageTexture


func _on_step_control_request_next_step() -> void:
	$ConwayGame.requestNextStep()


func _on_conway_game_board_done(bitmap: BitMap) -> void:
	pendingBitMap = bitmap
	waitingToRender = true


func _ready() -> void:
	_imageTexture = ImageTexture.new()
	imageNode.texture = _imageTexture
	
	isReady = true


func _process(_delta: float) -> void:
	if isReady and waitingToRender:
		showImage(pendingBitMap)
		waitingToRender = false


func showImage(bitmap: BitMap) -> void:
	var image = pendingBitMap.convert_to_image()
	_imageTexture.set_image(image)
	## need to do this after setting the image
	_imageTexture.set_size_override(Vector2i(500, 500))
