class_name AOC2024Day4Part1 extends CanvasLayer

## Advent of Code 2024 - Day 4 - Part 1
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/4]Day 4: Ceres Search[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the letters into a structure.[br]
## - Iterate over each cell[br]
## - Search for "XMAS" in all directions, bail as early as possible


@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	
	var letter_grid: LetterGrid = _parse_input(input_edit.text)
	
	var word: String = "XMAS"
	var occurrences: int = letter_grid.find_all_occurences_of(word)

	var result: String = "The word %s occurs a total of %d times." % [word, occurrences]
	print(result)
	results_label.text = result


func _parse_input(text: String) -> LetterGrid:
	
	print(text)
	var lines = text.split("\n")
	#print(lines)
	
	var letter_grid := LetterGrid.new()
	letter_grid.width = lines[0].length()
	
	# Feeding it in as one long string
	for line in lines:
		letter_grid.grid += line

	letter_grid.height = letter_grid.grid.length() / letter_grid.width
	
	return letter_grid


class LetterGrid:
	
	var width: int
	
	var height: int
	
	var grid: String = ""
	
	var directions: Array = [
		Vector2i.UP,
		Vector2i(1, -1), # RIGHT/UP
		Vector2i.RIGHT,
		Vector2i(1, 1), # RIGHT/DOWN
		Vector2i.DOWN,
		Vector2i(-1, 1), # LEFT/DOWN
		Vector2i.LEFT,
		Vector2i(-1, -1) # LEFT/UP
	]

	func get_letter_at(position: Vector2i) -> String:
		assert(position.x < width and position.y < height)
		return grid.substr(position.y * width + position.x, 1)


	func find_word_occurrences_at(word: String, position: Vector2i) -> int:
		var word_length = word.length()
		var grid_rect := Rect2i(Vector2i.ZERO, Vector2i(width, height)).grow(1)
		
		var occurrences: int = 0
		
		if word.substr(0, 1) != get_letter_at(position):
			return 0
			
		# Scan each direction
		for direction: Vector2i in directions:
			if not grid_rect.has_point(position + direction * word_length):
				#print("Word %s at pos %s in direction %s doesn't fit, ends up at %s" % [
					#word, position, direction, position + direction * word_length
				#])
				continue # doesn't fit
			
			var found: bool = true
			
			# Check each letter one by one
			for i: int in word.length():
				var letter = word.substr(i, 1)
				if get_letter_at(position + direction * i) != letter:
					found = false
					break
			
			if found:
				#print("Found word %s at position %s in direction %s" % [word, position, direction])
				occurrences += 1
			
		return occurrences
	
	
	func find_all_occurences_of(word: String) -> int:
		var all_occurrences = 0
		for y: int in height:
			for x: int in width:
				var position := Vector2i(x, y)
				var occurrences: int = find_word_occurrences_at(word, position)
				all_occurrences += occurrences
				#if occurrences:
					#print("Found %d occurrences at %s (%d so far)" % [occurrences, position, all_occurrences])
				
		return all_occurrences
