class_name AOC2024Day3Part1 extends CanvasLayer

## Advent of Code 2024 - Day 3 - Part 1
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/3]Day 3: Mull It Over[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - use a regular expression to parse out the numbers and multiply them.[br]


@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	
	var regex: RegEx = RegEx.new()
	regex.compile("mul\\((\\d{1,3}),(\\d{1,3})\\)")
	var matches = regex.search_all(input_edit.text)
	
	var total: int = 0
	for match in matches:
		total += mul(int(match.strings[1]), int(match.strings[2]))

	var result: String = "The total is %d." % [total]
	print(result)
	results_label.text = result


func mul(op1: int, op2: int) -> int:
	return op1 * op2
