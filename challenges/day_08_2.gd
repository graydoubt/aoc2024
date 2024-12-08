class_name AOC2024Day8Part2 extends CanvasLayer

## Advent of Code 2024 - Day 8 - Part 2
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/8]Day 8: Resonant Collinearity[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the input and extract the nodes into a dictionary
## - Iterate over the nodes and calculate the antinodes



@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	
	var node_types := _parse_input(input_edit.text)
	node_types.calc_antinodes()
	var anti_nodes: int = node_types.nodes["#"].size()
	

	var result: String = "The total number of antinodes is %d." % [anti_nodes]
	print(result)
	results_label.text = result


func _parse_input(text: String) -> NodeTypes:
	var node_types := NodeTypes.new()
	
	var width: int = 0
	var height: int = 0
	for line in text.split("\n"):
		if not line.length():
			continue
		width = line.length()
		var col: int = 0
		for column in line.split(""):
			if column != ".":
				node_types.add_node(column, Vector2i(height, col))
			col += 1
		height += 1
	
	node_types.bounds = Rect2i(0, 0, width, height)
	
	#print("%dx%d" % [width, height])
	return node_types
	
	
class NodeTypes:
	var nodes: Dictionary = {}
	
	var bounds: Rect2i
	
	func add_node(type: String, position: Vector2i):
		if not nodes.has(type):
			nodes[type] = []
		if not nodes[type].has(position):
			nodes[type].append(position)

	func calc_antinodes() -> int:
		for type in nodes:
			if type == "#":
				continue
			var num: int = nodes[type].size()
			
			for n1 in num - 1:
				for n2 in range(n1 + 1, num):
					_add_antinodes_for(nodes[type][n1], nodes[type][n2])
		return 0


	func _add_antinodes_for(node1: Vector2i, node2: Vector2i) -> int:
		var added: int = 0
		var diff: Vector2i = node2 - node1
		added += _add_antinodes(node1, -diff)
		added += _add_antinodes(node2, +diff)
		if added:
			add_node("#", node1)
			add_node("#", node2)
		return added


	func _add_antinodes(start: Vector2i, diff: Vector2i) -> int:
		var added: int = 0
		while bounds.has_point(start + diff):
			add_node("#", start + diff)
			added += 1
			start += diff
		return added


	func _to_string() -> String:
		var string = "Node Types:\n"
		for type in nodes:
			string += "%s: " % [type]
			for location in nodes[type]:
				string += "%s " % [location]
			string += "\n"
		return string
