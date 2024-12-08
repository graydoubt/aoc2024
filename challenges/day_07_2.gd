class_name AOC2024Day7Part2 extends CanvasLayer

## Advent of Code 2024 - Day 7 - Part 2
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/7]Day 7: Bridge Repair[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the input into an equation object
## - For each number read, iterate over the possible operators and store the results
## - If any of the results match the test value, the equation is valid



@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	
	var equations = _parse_input(input_edit.text)
	
	var total_calibration_result: int = 0
	
	for equation in equations:
		if equation.is_valid():
			total_calibration_result += equation.test_value

	var result: String = "The total calibration result is %d." % [total_calibration_result]
	print(result)
	results_label.text = result


func _parse_input(text: String) -> Array[Equation]:
	
	print(text)
	
	var equations: Array[Equation] = []
	var grid: Array[String] = []
	
	var lines: Array[String]
	lines.assign(text.split("\n"))
	
	for line in lines:
		var values: Array[String]
		values.assign(line.split(": "))
		match values:
			[var test_value, var operands]:
				var equation := Equation.new()
				equation.test_value = test_value
				for operand in operands.split(" "):
					equation.add_operand(int(operand))
				equations.append(equation)
			
	return equations


class Equation:
	var test_value: int
	
	var results: Array[int] = []
	
	var operators: Dictionary = {
		"*": op_multiply,
		"+": op_add,
		"||": op_concatenate
	}
	
	
	func add_operand(operand: int) -> void:
		if not results.size():
			results = [operand]
			return
		
		var new_results: Array[int] = []
		
		for result in results:
			for operator in operators:
				new_results.append(operators[operator].call(result, operand))
		
		results = new_results
	
	
	func is_valid() -> bool:
		return results.has(test_value)


	func op_multiply(op1: int, op2: int) -> int:
		return op1 * op2
	
	
	func op_add(op1: int, op2: int) -> int:
		return op1 + op2
	
	
	func op_concatenate(op1: int, op2: int) -> int:
		return int("%d%d" % [op1, op2])
	
