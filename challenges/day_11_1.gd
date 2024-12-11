class_name AOC2024Day11Part1 extends CanvasLayer

## Advent of Code 2024 - Day 11 - Part 1
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/11]Day 11: Plutonian Pebbles[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the numbers into an array.[br]
## - Iterate over each element in the array and generate a new array.[br]
## - Repeat the requested amount of times[br]


@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:

	var stones: Stones = _parse_input(input_edit.text)

	var blink_times: int = 25
	for i in blink_times:
		stones.blink()
		
	var num_stones: int = stones.count()

	var result: String = "You have %d stones after blinking %d times." % [num_stones, blink_times]
	print(result)
	results_label.text = result


func _parse_input(text: String) -> Stones:
	var stones := Stones.new()
	
	for num in text.split(" "):
		stones.add_stone(int(num))

	return stones


class Stones:

	var stones: PackedInt64Array = []
	
	func add_stone(stone: int) -> void:
		stones.append(stone)


	func blink() -> void:
		var new_stones: PackedInt64Array = []
		
		for stone in stones:
			# If the stone is engraved with the number 0, it is replaced by a stone
			# engraved with the number 1.
			if stone == 0:
				new_stones.append(1)
			
			# If the stone is engraved with a number that has an even number of
			# digits, it is replaced by two stones. The left half of the digits are
			# engraved on the new left stone, and the right half of the digits are
			# engraved on the new right stone. (The new numbers don't keep extra
			# leading zeroes: 1000 would become stones 10 and 0.)
			elif stone_has_even_number_of_digits(stone):
				var split: Array[int] = split_number_in_half(stone)
				new_stones.append(split[0])
				new_stones.append(split[1])
			
			# If none of the other rules apply, the stone is replaced by a new
			# stone; the old stone's number multiplied by 2024 is engraved on the
			# new stone.
			else:
				new_stones.append(stone * 2024)
		stones = new_stones
	
	func stone_has_even_number_of_digits(stone: int) -> bool:
		var digits = str(stone).length()
		var is_even = digits % 2 == 0
		return is_even
	
	func split_number_in_half(num: int) -> Array[int]:
		var string = str(num)
		var len = string.length()
		return [
			int(string.substr(0, len / 2)),
			int(string.substr(len / 2))
		]
	
	
	func count() -> int:
		return stones.size()
