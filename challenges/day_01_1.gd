class_name AOC2024Day1Part1 extends CanvasLayer

## Advent of Code 2024 - Day 1 - Part 1
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/1]Day 1: Historian Hysteria[/url]
## [br]
## [br]
## My solution parses the numbers into separate arrays,
## sorts them, and then compares the two arrays.

@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	var list_pair := parse_input(input_edit.text)
	print_debug(list_pair)
	list_pair.sort()
	print_debug(list_pair)
	
	results_label.text = "The total distance between the two lists is: %d" % [list_pair.calc_total_distance()]


func parse_input(text: String) -> ListPair:
	var regex: RegEx = RegEx.new()
	# Using a regular expression to parse a line of input:
	# A number followed by whitespace followed by another number.
	regex.compile("(\\d+)\\s*?(\\d+)")
	
	var list_pair: ListPair = ListPair.new()
	
	for result: RegExMatch in regex.search_all(text):
		list_pair.list1.append(int(result.strings[1]))
		list_pair.list2.append(int(result.strings[2]))
	
	return list_pair


class ListPair:
	var list1: Array[int]
	var list2: Array[int]
	
	func _to_string() -> String:
		var string := "ListPair:\n"
		for i in list1.size():
			string += "%3d, %3d\n" % [list1[i], list2[i]]
		return string
	
	
	func sort() -> void:
		list1.sort()
		list2.sort()


	func calc_total_distance() -> int:
		var distance: int = 0
		for i in list1.size():
			var diff = abs(list1[i] - list2[i])
			distance += diff
		return distance
