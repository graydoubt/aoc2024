class_name AOC2024Day6Part2 extends CanvasLayer

## Advent of Code 2024 - Day 6 - Part 2
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/6]Day 6: Guard Gallivant[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the input into a tile array (could also be a tilemap) and the guard object
## - Move the guard and update the terrain
## - Count how many unique locations the guard walked on (e.g. visited tiles list)
## - Loop detection can use a similar list, but needs to also track the direction.
##   This is done with a Vector3 to track position + direction.
##
## Brute-forcing it and calling it good enough. :)
## To find the possible list of obstacles, only consider positions that cause the
## guard to turn into another obstacle. Since the guard only turns right, only scan
## the obstacles to the guard's right.
## Obstacles can only be placed into cells that the guard hasn't visited yet.
## I.e. we cannot "close the gate" behind the guard to get him on the way back.


@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label

var terrain: Terrain

var guard: Guard



func _on_results_button_pressed() -> void:
	
	_parse_input(input_edit.text)
	
	var obstacles: Array[Vector2i] = []
	var obstacle_positions: int = 0
	
	var done: bool = false
	while not done:
		if (
			guard.has_obstable_on_the_right()
			and not guard.has_obstacle_in_front()
			and not guard.has_visited_next_step()
		):
			# make a copy, set the obstacle, and let 'er rip
			var terrain_copy := terrain.clone()
			var guard_copy := guard.clone()
			guard_copy.terrain = terrain_copy
			var obstacle_pos: Vector2i = guard.position + guard.direction
			if terrain_copy.has_cell(obstacle_pos):
				terrain_copy.set_cell(obstacle_pos, "#")
				if guard_copy.has_infinite_loop():
					print("Infinite loop! (%d)" % [obstacle_positions + 1])
					if not obstacles.has(obstacle_pos):
						obstacles.append(obstacle_pos)
						obstacle_positions += 1
			
		done = guard.move()
	
	var result: String = "There are %d possible obstacle positions." % [obstacle_positions]
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
	
	
	func clone() -> Terrain:
		var copy: Terrain = Terrain.new()
		copy.width = width
		copy.height = height
		copy.boundaries = boundaries
		copy.cells = cells.duplicate()
		return copy
	
	
	func resize(size: Vector2i) -> void:
		width = size.x
		height = size.y
		boundaries = Rect2i(0, 0, size.x, size.y)
	
	
	func set_cell(position: Vector2i, char: String) -> void:
		cells[position.y * width + position.x] = char
	
	
	func get_cell(position: Vector2i) -> String:
		if not has_cell(position):
			return ""
		return cells[position.y * width + position.x]
	
	
	func has_cell(position: Vector2i) -> bool:
		return boundaries.has_point(position)
	
	
	func is_walkable(position: Vector2i) -> bool:
		var cell: String = get_cell(position)
		return cell == "." or cell == ""


class Guard:
	
	enum Directions {
		UP = 1,
		RIGHT = 2,
		DOWN = 3,
		LEFT = 4
	}
	var position: Vector2i
	
	var direction: Vector2i
	
	var terrain: Terrain
	
	var visited_cells: Array[Vector2i] = []
	
	var loop_detection: Array[Vector3i]
	
	func clone() -> Guard:
		var copy := Guard.new()
		copy.position = position
		copy.direction = direction
		copy.visited_cells = visited_cells.duplicate()
		return copy
	
	
	func start_at(pos: Vector2i) -> void:
		position = pos
		visited_cells.append(pos)
	
	
	## Rotate the guard by 90 degrees.
	func rotate() -> Vector2i:
		match direction:
			Vector2i.UP:
				return Vector2i.RIGHT
			Vector2i.RIGHT:
				return Vector2i.DOWN
			Vector2i.DOWN:
				return Vector2i.LEFT
			Vector2i.LEFT:
				return Vector2i.UP
		return Vector2i.ZERO

	
	func has_obstacle_in_front() -> bool:
		return terrain.get_cell(position + direction) == "#"
	
	func has_visited_next_step() -> bool:
		return visited_cells.has(position + direction)
	
	## Checks whether there's an obstacle to the right of this guard
	func has_obstable_on_the_right() -> bool:
		var new_direction: Vector2i = rotate()
		var distance: int = 1
		while terrain.has_cell(position + new_direction * distance):
			if terrain.get_cell(position + new_direction * distance) == "#":
				return true
			distance += 1
		return false
	
	
	func move() -> bool:
		if not terrain.has_cell(position + direction):
			return true
		
		if terrain.is_walkable(position + direction):
			position = position + direction
			if not visited_cells.has(position):
				visited_cells.append(position)
		else:
			direction = rotate()
		
		return false
	
	
	func has_infinite_loop() -> bool:
		var done: bool = false
		while not done:
			done = move()
			if not done:
				var loop_id = Vector3i(position.x, position.y, _direction_to_int(direction))
				if loop_detection.has(loop_id):
					return true
				loop_detection.append(loop_id)
		
		return false


	func _direction_to_int(dir: Vector2i) -> int:
		match dir:
			Vector2i.UP: return Directions.UP
			Vector2i.RIGHT: return Directions.RIGHT
			Vector2i.DOWN: return Directions.DOWN
			Vector2i.LEFT: return Directions.LEFT
		push_error("Failed turning direction %s into int" % [dir])
		return 0
