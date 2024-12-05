class_name AOC2024Day4Part2 extends CanvasLayer

## Advent of Code 2024 - Day 4 - Part 2
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/4]Day 4: Ceres Search[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the letters into a structure.[br]
## - Represent the "X-MAS" with another structure.[br]
## - Search for the "X-MAS" by rotating it and checking against a match


@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	
	var letter_grid: LetterGrid = _parse_input(input_edit.text)
	
	var occurrences: int = letter_grid.find_xmas_occurences()

	var result: String = "'X-MAS' occurs a total of %d times." % [occurrences]
	print(result)
	results_label.text = result


func _parse_input(text: String) -> LetterGrid:
	
	print(text)
	var lines = text.split("\n")
	
	var letter_grid := LetterGrid.new()
	letter_grid.width = lines[0].length()
	
	# Feeding it in as one long string
	for line in lines:
		letter_grid.grid += line

	letter_grid.height = letter_grid.grid.length() / letter_grid.width
	
	return letter_grid


class PatternSymbol:
	var character: String
	var offset: Vector2i
	
	func _init(char: String, pos: Vector2i):
		character = char
		offset = pos


class XMAS:
	var symbols: Array[PatternSymbol] = [
		PatternSymbol.new("A", Vector2i.ZERO),
		PatternSymbol.new("S", Vector2i(1, -1)),
		PatternSymbol.new("S", Vector2i(1, 1)),
		PatternSymbol.new("M", Vector2i(-1, -1)),
		PatternSymbol.new("M", Vector2i(-1, 1))
	]
	
	func rotate90() -> void:
		for symbol: PatternSymbol in symbols:
			var vec: Vector2i = symbol.offset
			if vec == Vector2i.ZERO:
				continue
			symbol.offset = Vector2(symbol.offset).rotated(PI / 2).snapped(Vector2.ONE)


	func pattern_match(grid: LetterGrid, position: Vector2i) -> bool:
		for symbol: PatternSymbol in symbols:
			if grid.get_letter_at(position + symbol.offset) != symbol.character:
				return false
		return true


class LetterGrid:
	
	var width: int
	
	var height: int
	
	var grid: String = ""


	func get_letter_at(position: Vector2i) -> String:
		assert(position.x < width and position.y < height)
		return grid.substr(position.y * width + position.x, 1)


	func find_xmas_at(position: Vector2i) -> bool:
		var xmas := XMAS.new()
		for i in 4:
			if xmas.pattern_match(self, position):
				return true
			xmas.rotate90()
		return false
	
	
	func find_xmas_occurences() -> int:
		var occurrences = 0
		for y: int in range(1, height - 1):
			for x: int in range(1, width - 1):
				var position := Vector2i(x, y)
				if find_xmas_at(position):
					occurrences += 1
		return occurrences
