class_name AOC2024Day2Part2 extends CanvasLayer

## Advent of Code 2024 - Day 2 - Part 2
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/2]Day 2: Red-Nosed Reports[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read each line into a Report object.[br]
## - "Run" each report, which validates whether it is "Safe" or "Unsafe".[br]
## - If unsafe, brute-force by taking out a single level and trying again.[br]
## The requested answer is how many reports are safe.

@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label


func _on_results_button_pressed() -> void:
	var reports := parse_input(input_edit.text)
	
	
	var num_safe: int = reports.reduce(
		func (accum, report: Report) -> int:
			var score = report.calc_score()
			
			if not score:
				# Score failed, let the Problem Dampener kick in and brute-force all
				# permutations by trying it with each level removed.
				for i in report.levels.size():
					var permutation := Report.new()
					permutation.levels = report.levels.duplicate()
					permutation.levels.pop_at(i)
					if permutation.calc_score():
						score = 1
						break
			return accum + score,
		0
	)
	
	var result: String = "%d out of %d reports are safe." % [num_safe, reports.size()]
	print(result)
	results_label.text = result


func parse_input(text: String) -> Array[Report]:
	var reports: Array[Report] = []
	
	# String.split() returns a PackedStringArray.
	# Forcing it to cast to Array[String] implicitly.
	var lines: Array[String]
	lines.assign(text.split("\n"))
	for line in lines:
		if not line:
			continue
		var nums: Array[String]
		nums.assign(line.split(" "))
		var report := Report.new()
		report.levels.assign(nums.map(func(num: String) -> int: return int(num)))
		
		reports.append(report)
	
	return reports



class Report:
	var levels: Array[int]

	func calc_score() -> int:
		var has_previous_delta: bool = false
		var previous_delta: int = 0
		
		var has_previous_level: bool = false
		var previous_level: int = 0
		
		var score: int = 1
		
		for level in levels:

			# Handle the first level in the report
			if not has_previous_level:
				has_previous_level = true
				previous_level = level
				continue
			
			var delta = level - previous_level
			
			# Rule: Any two adjacent levels differ by at least one and at most three.
			# Otherwise, the levels are unsafe.
			if abs(delta) > 3 or abs(delta) < 1:
				score = 0
				return score
			
			# Handle the first delta in the report
			if not has_previous_delta:
				has_previous_delta = true
				previous_level = level
				previous_delta = delta
				continue
			
			# Detect whether levels changed from increasing to decreasing or vice versa
			if sign(previous_delta) != sign(delta):
				score = 0
				return score
			
			previous_level = level
			previous_delta = delta
		
		return score

	func _to_string() -> String:
		var string := "Report: "
		for i in levels.size():
			string += "%d " % [levels[i]]
		return string
