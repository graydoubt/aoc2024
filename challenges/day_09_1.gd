class_name AOC2024Day9Part1 extends CanvasLayer

## Advent of Code 2024 - Day 9 - Part 1
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/9]Day 9: Disk Fragmenter[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the input and build an array:
##   - Each element represents a block with the file ID.
##   - Free space is represented as a NULL value.
## - Start at the end of the array and move blocks to empty space at the beginning.
## 



@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	var defragger := _parse_input(input_edit.text)
	#print(defragger)
	defragger.defrag()
	#print(defragger)
	var checksum: int = defragger.calc_checksum()

	var result: String = "The checksum is %d." % [checksum]
	print(result)
	results_label.text = result


func _parse_input(text: String) -> Defragger:
	var defragger := Defragger.new()
	
	var mode: Array = ['B', 'F']
	var mode_index: int = 0
	var file_id: int = 0
	
	# Reading data has to alternate between reading a file ID and free space
	for num in text.split(""):
		match mode[mode_index]:
			'B': 
				defragger.add_blocks(file_id, int(num))
				file_id += 1
			'F':
				defragger.add_blocks(null, int(num))
		mode_index = wrapi(mode_index + 1, 0, mode.size())
	
	return defragger


class Defragger:
	
	var blocks: Array = []
	
	func add_blocks(file_id, count: int) -> void:
		for i in count:
			blocks.append(file_id)
	
	
	func defrag() -> void:
		var free_index: int = 0
		for block_index in range(blocks.size() - 1, 0, -1):
			free_index = blocks.find(null, free_index)
			if free_index < 0:
				break
			if free_index >= block_index:
				break
			blocks[free_index] = blocks[block_index]
			blocks[block_index] = null


	func calc_checksum() -> int:
		var checksum: int = 0
		for block_index in blocks.size():
			if blocks[block_index] == null:
				break
			checksum += blocks[block_index] * block_index
		return checksum
	
	
	func _to_string() -> String:
		return blocks.reduce(
			func (s, i):
				if i == null:
					return "%s." % [s]
				return "%s%s" % [s, i],
			""
		)
