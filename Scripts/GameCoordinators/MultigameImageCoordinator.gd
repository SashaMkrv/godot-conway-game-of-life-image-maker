@tool
extends Node

#@onready
#var gamesNode:= $Games
@onready
var imageConstuctor:= $ImageConstructor
@onready
var imageNode:= $TextureRect
@onready
var ghostNode:= $TextureRectGhost
@onready
var paletteGenerator:= $PaletteGenerator
@onready
var settingsUi:= $SettingsUI

## Number of games to run. Is the number of bits for your colour palette
@export_range(1, 8)
var numberOfGames := 1:
	set(value):
		numberOfGames = value
		updatedNumberOfGames()

## Size of your game grid
@export_range(1, 1000)
var gridSize := 25:
	set(value):
		gridSize = value
		updatedGridSize()

## Seed for your games initial state
@export
var gameSeed := "seed":
	set(value):
		gameSeed = value
		updatedSeed()

@export
var colorPalette : Array[Color] = [Color.BLACK]:
	set(value):
		colorPalette = value
		updatedPalette()

@export
var tiled: bool = false:
	set(value):
		tiled = value
		updatedTiled()


var _gameControllers : Array[ConwayGame] = []
var pendingGameBoards: Array[BitMap] = []

var waitingForGames := 0
var waitingToRender := false

var _imageTexture:= ImageTexture.new()
var _ghostTexture:= ImageTexture.new()
var _currentImage: Image
var _paletteRng:= RandomNumberGenerator.new()

func updatedPalette() -> void:
	if is_node_ready():
		imageConstuctor.palette = colorPalette
	requestCurrentMap()

func updatedTiled() -> void:
	if is_node_ready():
		setStretchMode()

func setStretchMode() -> void:
	imageNode.stretch_mode = TextureRect.StretchMode.STRETCH_TILE if (tiled) else TextureRect.StretchMode.STRETCH_KEEP
	ghostNode.stretch_mode = TextureRect.StretchMode.STRETCH_TILE if (tiled) else TextureRect.StretchMode.STRETCH_KEEP

func updatedSeed() -> void:
	updateRng()
	initializeGames()

func updatedGridSize() -> void:
	updateRng()
	initializeGames()

func updatedNumberOfGames() -> void:
	updateRng()
	initializeGames()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	imageNode.texture = _imageTexture
	ghostNode.texture = _ghostTexture
	imageConstuctor.palette = colorPalette
	# NOTE after this initial update, the source of truth for fields comes from the UI node.
	updateUiFields()
	setStretchMode()
	
	initializeGames()

func updateUiFields() -> void:
	settingsUi.updateSeed(gameSeed)
	settingsUi.updateGridSize(gridSize)
	settingsUi.updateNumberOfGames(numberOfGames)

func updateRng() -> void:
	_paletteRng.seed = hash(gameSeed)

func initializeGames() -> void:
	_reset_state()
	_lose_games()
	
	for game in numberOfGames:
		var conwayGame = ConwayGame.new()
		conwayGame.gridSize = gridSize
		conwayGame.seed = gameSeed + str(game)
		conwayGame.boardDone.connect(_game_completes_board)
		add_child(conwayGame)
		_gameControllers.append(conwayGame)


func requestCurrentMap() -> void:
	_reset_state()
	for game in _gameControllers:
		game.requestCurrentMap()

func requestNextStep() -> void:
	_reset_state()
	for game in _gameControllers:
		game.requestNextStep()

func _reset_state() -> void:
	waitingForGames = numberOfGames
	waitingToRender = false
	pendingGameBoards = []


func _lose_games() -> void:
	for controller in _gameControllers:
		controller.boardDone.disconnect(_game_completes_board)
	_gameControllers = []


func _game_completes_board(board: BitMap) -> void:
	waitingForGames -= 1
	pendingGameBoards.append(board)
	if waitingForGames < 1:
		waitingToRender = true


func _process(_delta: float) -> void:
	if waitingToRender:
		var image: Image = imageConstuctor.createImage(pendingGameBoards)
		
		if _currentImage != null:
			_ghostTexture.set_image(_currentImage)
			_ghostTexture.set_size_override(Vector2i(500, 500))
		
		_imageTexture.set_image(image)
		_imageTexture.set_size_override(Vector2i(500, 500))
		
		_currentImage = image
		
		_reset_state()


func _on_step_controller_request_next_step() -> void:
	requestNextStep()


func _on_copy_detector_request_image_to_clipboard() -> void:
	copyCurrentImageToClipboard()


## Specifically does not copy image to clipboard. Chucks it into a pictures folder instead.
func copyCurrentImageToClipboard() -> void:
	if _currentImage == null:
		print_debug("no image logged yet")
	
	
	# this is bad and rude, but also I wish we weren't saving anything anywhere at all.
	# TODO commit to saving and move this to an onready var or resolve your moral issues.
	
	var saver = $ImageSaver
	if saver == null:
		print_debug("no method for saving images")
	
	saver.trySaveImage(_currentImage)


func _on_palette_request_detector_palette_requested() -> void:
	generateAndReplacePalette(numberOfGames + 1, _paletteRng)

func generateAndReplacePalette(paletteSize: int, rng: RandomNumberGenerator) -> void:
	if paletteGenerator == null:
		print_debug("no palette generator available")
	colorPalette = paletteGenerator.requestPalette(paletteSize, rng)


func _on_settings_ui_next_round_requested() -> void:
	requestNextStep()


func _on_settings_ui_new_palette_requested() -> void:
	generateAndReplacePalette(numberOfGames + 1, _paletteRng)


func _on_settings_ui_save_image_requested() -> void:
	copyCurrentImageToClipboard()


func _on_settings_ui_grid_size_changed(newSize: int) -> void:
	gridSize = newSize


func _on_settings_ui_number_of_games_changed(newNumber: int) -> void:
	numberOfGames = newNumber


func _on_settings_ui_seed_changed(newSeed: String) -> void:
	gameSeed = newSeed
