class_name AOC2024Day6Part1 extends CanvasLayer

## Advent of Code 2024 - Day 6 - Part 1
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/6]Day 6: Guard Gallivant[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the input into a tile array (could also be a tilemap) and the guard object
## - Move the guard and update the terrain
## - Count how many unique locations the guard walked on (e.g. visited tiles list)



@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label

var terrain: Terrain

var guard: Guard

#var grid: Array[String]

#@export var tile_map: TileMap


func _on_results_button_pressed() -> void:
	
	_parse_input(input_edit.text)
	
	var done: bool = false
	while not done:
		done = guard.move()
	
	var visited_tiles: int = guard.visited_cells.size()
	
	var result: String = "The guard visited %d unique tiles." % [visited_tiles]
	print(result)
	results_label.text = result


func _parse_input(text: String) -> void:
	
	print(text)
	
	var grid: Array[String] = []
	
	var lines: Array[String]
	lines.assign(text.split("\n"))
	
	var width: int = lines[0].length()
	
	terrain = Terrain.new()

	var pos_y: int = 0
	for line: String in lines:
		
		var pos_x: int = 0
		for char: String in line.split(""):
			match char:
				"^":
					guard = Guard.new()
					guard.start_at(Vector2i(pos_x, pos_y))
					guard.direction = Vector2i.UP
					guard.terrain = terrain
					print("Found guard at %s" % [guard.position])
					grid.append(".")
				_:
					grid.append(char)
			pos_x += 1
		pos_y += 1
	
	var height: int = grid.size() / width
	print("Grid is %d x %d" % [width, height])
	terrain.resize(Vector2i(width, height))
	terrain.cells = grid


class Terrain:
	
	var width: int
	
	var height: int
	
	var boundaries: Rect2i
	
	var cells: Array[String] = []
	
	func resize(size: Vector2i) -> void:
		width = size.x
		height = size.y
		boundaries = Rect2i(0, 0, size.x, size.y)
		print("Grid is %s" % [boundaries])
	
	
	func set_cell(position: Vector2i, char: String) -> void:
		cells[position.y * width + position.x] = char
	
	
	func get_cell(position: Vector2i) -> String:
		return cells[position.y * width + position.x]
	
	
	func has_cell(position: Vector2i) -> bool:
		return boundaries.has_point(position)
	
	
	func is_walkable(position: Vector2i) -> bool:
		if not boundaries.has_point(position):
			return false
		return get_cell(position) == "."


class Guard:
	
	var position: Vector2i
	
	var direction: Vector2i
	
	var terrain: Terrain
	
	var visited_cells: Array[Vector2i] = []
	
	func start_at(pos: Vector2i) -> void:
		position = pos
		visited_cells.append(pos)
	
	## Rotate the guard by specified [param degrees]s.
	func rotate(degrees: int = 90) -> void:
		var radians = deg_to_rad(degrees)
		direction = Vector2(direction).rotated(radians).snapped(Vector2.ONE)
		#print("Turning to %s" % [direction])
	
	
	func move() -> bool:
		var done: bool = false
		if not terrain.has_cell(position + direction):
			return true
		
		while not terrain.is_walkable(position + direction):
			rotate()
		
		position = position + direction
		if not visited_cells.has(position):
			visited_cells.append(position)
		return done
