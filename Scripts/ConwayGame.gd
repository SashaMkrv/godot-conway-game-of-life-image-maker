@tool
extends Node
class_name ConwayGame

signal boardDone(bitmap: BitMap)

@export_range(1, 1000) var gridSize: int
@export var seed: String

const SURROUNDINGS_MASK = [
	[-1, -1], [-1, 0], [-1, 1],
	[0, -1], [0, 1],
	[1, -1], [1, 0], [1, 1]
	]

var gameBoard: BitMap
## BitMaps have a convert_to_image() function
## white pixels for true, black for false.
## has resize function as well

func requestNextStep() -> void:
	gameBoard = nextRound(gameBoard, SURROUNDINGS_MASK)
	boardDone.emit(gameBoard)

func requestCurrentMap() -> void:
	boardDone.emit(gameBoard)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameBoard = BitMap.new()
	gameBoard.create(Vector2i(gridSize, gridSize))
	
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(seed)
	
	gameBoard = populateGameBoard(rng, gameBoard)
	boardDone.emit(gameBoard)


# Returns a populated game board bitmap.
func populateGameBoard(rng: RandomNumberGenerator, map: BitMap) -> BitMap:
	var newMap = map.duplicate()
	var size = newMap.get_size()
	var popChance: int
	for x in size.x:
		for y in size.y:
			# Change population probability (put this into a strategy of some kind. along with most of the actual conway stuff)
			popChance = rng.randi_range(0, 5)
			if popChance <= 1:
				newMap.set_bit(x, y, true)
	return newMap


func nextRound(map: BitMap, mask: Array) -> BitMap:
	var newMap := map.duplicate()
	var size := map.get_size()
	## man I want linq functions. but who knows how things will change.
	var currentDensity := 0
	var currentCellState := false
	for x in size.x:
		for y in size.y:
			currentCellState = getCurrentCellState(map, size, x, y)
			currentDensity = sumLiveCellsInMask(map, size, mask, x, y)
			if currentCellState:
				if currentDensity < 2 or currentDensity > 3:
					newMap.set_bit(x, y, false)
			else:
				if currentDensity == 3: newMap.set_bit(x, y, true)
	return newMap
	# so we can have this updated by button press instead.
	# pity you can't extrapolate previous steps from the current
	# data without keeping an infinite game board.

func sumLiveCellsInMask(map: BitMap, size: Vector2, mask: Array, x: int, y: int) -> int:
	var sum := 0
	var live := false
	for coordinates in mask:
		live = getCurrentCellState(map, size, x + coordinates[0], y + coordinates[1])
		if (live):
			sum += 1
	return sum

func getCurrentCellState(map: BitMap, size: Vector2, _x: int, _y: int) -> bool:
	var x:= posmod(_x, size.x)
	var y:= posmod(_y, size.y)
	
	return map.get_bit(x, y)
	## this determines how the game views out of bounds cells. Are they falsey? truthy? do they wrap? how do they wrap?
