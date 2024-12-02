class_name AOC2024Day1Part2 extends CanvasLayer

## Advent of Code 2024 - Day 1 - Part 2
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/1]Day 1: Historian Hysteria[/url]
## [br]
## [br]
## You have to solve the first problem before the second part is visible.
## My solution still parses the numbers into separate arrays.
## Sorting isn't necessary for this part.
## Similarity is easily calculated since Godot provides [method Array.count].

@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	var list_pair := parse_input(input_edit.text)
	print_debug(list_pair)
	#list_pair.sort()
	#print_debug(list_pair)
	
	var result: String = "The similarity between the two lists is: %d" % [list_pair.calc_similarity()]
	print(result)
	results_label.text = result


func parse_input(text: String) -> ListPair:
	var regex: RegEx = RegEx.new()
	# Using a regular expression to parse a line of input:
	# A number followed by whitespace followed by another number.
	regex.compile("(\\d+)\\s*?(\\d+)")
	
	var list_pair: ListPair = ListPair.new()
	
	for result: RegExMatch in regex.search_all(text):
		list_pair.add_pair(
			int(result.strings[1]),
			int(result.strings[2])
		)
	
	return list_pair


class ListPair:
	var list1: Array[int]
	var list2: Array[int]
	
	
	func add_pair(num1: int, num2: int) -> void:
		list1.append(num1)
		list2.append(num2)
	
	
	func sort() -> void:
		list1.sort()
		list2.sort()


	func calc_similarity() -> int:
		var similarity: int = 0
		for i in list1.size():
			var num1 = list1[i]
			var score = num1 * list2.count(num1)
			similarity += score
		return similarity


	func _to_string() -> String:
		var string := "ListPair:\n"
		for i in list1.size():
			string += "%3d, %3d\n" % [list1[i], list2[i]]
		return string
