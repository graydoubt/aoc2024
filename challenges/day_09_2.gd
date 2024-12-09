class_name AOC2024Day9Part2 extends CanvasLayer

## Advent of Code 2024 - Day 9 - Part 2
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/9]Day 9: Disk Fragmenter[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the input and build an array:
##   - Each element represents a block with the file ID.
##   - Free space is represented as a NULL value.
##   - For part 2, an array of files is also built to make it simpler to operate on a per-file basis
## - Iterate over each file and find a large enough contiguous free block to move the file to.



@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	var defragger := _parse_input(input_edit.text)
	#print(defragger)
	defragger.defrag2()
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


class File:
	var id: int = -1
	var offset: int
	var block_size: int


class Defragger:
	
	var blocks: Array = []
	
	var files: Array = []
	
	func add_blocks(file_id, count: int) -> void:
		if file_id != null:
			var file := File.new()
			file.id = file_id
			file.block_size = count
			file.offset = blocks.size()
			files.append(file)

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


	func defrag2() -> void:
		files.reverse()
		
		for file: File in files:
			var offset: int = _find_contiguous_free_block(file.block_size, file.offset)
			if offset == -1:
				continue
			_move_file(file, offset)
	
	
	func _find_contiguous_free_block(block_size: int, offset) -> int:
		
		var start: int = blocks.find(null, 0)
		if start < 0 or start > offset:
			return -1
		
		var size: int = 1
		while size < block_size:
			if blocks[start + size] == null:
				size += 1
			else:
				start = blocks.find(null, start + size + 1)
				if start < 0 or start > offset:
					return -1
				size = 1
		
		return start


	func _move_file(file: File, dest_offset: int):
		for i in file.block_size:
			blocks[dest_offset+i] = blocks[file.offset+i]
			blocks[file.offset+i] = null


	func calc_checksum() -> int:
		var checksum: int = 0
		for block_index in blocks.size():
			if blocks[block_index] != null:
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
