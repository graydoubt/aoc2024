class_name AOC2024Day10Part1 extends CanvasLayer

## Advent of Code 2024 - Day 10- Part 1
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/10]Day 10: Hoof It[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the numbers into a topographic map structure.[br]
## - Use a recursive search to find trails[br]


@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:

	var map: TopographicMap = _parse_input(input_edit.text)

	var word: String = "XMAS"
	var score: int = map.find_trailhead_score()

	var result: String = "The sum of all trailhead scores is %d." % [score]
	print(result)
	results_label.text = result


func _parse_input(text: String) -> TopographicMap:

	var lines = text.split("\n")
	var map := TopographicMap.new()
	map.width = lines[0].length()

	for line in lines:
		for height in line.split(""):
			map.add(int(height))

	map.height = map.map.size() / map.width

	return map


class TopographicMap:

	var width: int

	var height: int

	var map: PackedInt32Array = []

	var trailheads: Array[Vector2i] = []

	var directions: Array = [
		Vector2i.UP,
		Vector2i.RIGHT,
		Vector2i.DOWN,
		Vector2i.LEFT
	]


	func add(level: int):
		if level == 0:
			trailheads.append(Vector2i(map.size() % width, map.size() / width))
		map.append(level)


	func get_level_at(position: Vector2i) -> int:
		assert(position.x < width and position.y < height)
		return map[position.y * width + position.x]


	func find_trailhead_score() -> int:
		var score: int = 0
		for head in trailheads:
			var trailends = find_trail(head, 0)
			score += trailends.size()
		return score


	func find_trail(position: Vector2i, level: int) -> Array[Vector2i]:
		var trail_ends: Array[Vector2i] = []

		if position.x < 0 or position.y < 0 or position.x >= width or position.y >= height:
			return trail_ends

		if get_level_at(position) != level:
			return trail_ends

		if get_level_at(position) == 9:
			trail_ends.append(position)
		else:
			for direction: Vector2i in directions:
				var ends: Array[Vector2i] = find_trail(position + direction, level + 1)
				for e in ends:
					if not trail_ends.has(e):
						trail_ends.append(e)
		return trail_ends
