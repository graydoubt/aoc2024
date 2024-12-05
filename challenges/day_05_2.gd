class_name AOC2024Day5Part2 extends CanvasLayer

## Advent of Code 2024 - Day 5 - Part 2
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/5]Day 5: Print Queue[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the input into "order rules" and "pages"
## - Apply bubble sort:
##   - Iterate over rules and swap numbers
##   - Stop iterating if no modifications needed to be made
## - Add up the middle page numbers



@export var input_edit: TextEdit

@export var results_button: Button:
	set(value):
		results_button = value
		results_button.pressed.connect(_on_results_button_pressed)

@export var results_label: Label

var ordering_rules: Array[PageOrderingRule] = []

var page_sets: Array[PageSet] = []

func _on_results_button_pressed() -> void:
	
	ordering_rules.clear()
	page_sets.clear()
	_parse_input(input_edit.text)
	
	print("%d ordering rules loaded." % [ordering_rules.size()])
	print("%d sets of pages loaded." % [page_sets.size()])
	
	var invalid_pages = page_sets.filter(
		func(page_set: PageSet) -> bool:
			for rule in ordering_rules:
				if not rule.is_valid(page_set):
					return true
			return false
	)
		
	for page_set: PageSet in invalid_pages:
		var swapped: bool = true
		var iterations: int = 0
		while swapped:
			swapped = false
			for rule in ordering_rules:
				if rule.apply(page_set):
					swapped = true
			iterations += 1
			
		#print("PageSet corrected after %d iterations" % [iterations])
		#print(page_set.pages)

	var middle_page_summation: int = 0
	
	for page: PageSet in invalid_pages:
		middle_page_summation += page.get_middle_number()
	
	var result: String = "All incorrectly-ordered middle pages add up to %d." % [middle_page_summation]
	print(result)
	results_label.text = result


func _parse_input(text: String):
	
	print(text)
	
	var input: Array[String]
	input.assign(text.split("\n\n"))
	match input:
		[var rules, var pages]:
			for rule: String in rules.split("\n"):
				var order_rule = rule.split("|")
				var por := PageOrderingRule.new()
				por.page_low = order_rule[0]
				por.page_high = order_rule[1]
				ordering_rules.append(por)
			
			
			for page: String in pages.split("\n"):
				
				var string_array: Array[String]
				string_array.assign(page.split(","))
				
				var page_set := PageSet.new()
				page_set.pages.assign(string_array.map(func (str: String) -> int: return int(str)))
				page_sets.append(page_set)


class PageOrderingRule:
	var page_low: int
	var page_high: int
	
	## Ensures the [member page_low] comes before [member page_high].
	func is_valid(page_set: PageSet) -> bool:
		if not page_set.pages.has(page_low):
			return true
		if not page_set.pages.has(page_high):
			return true
		return page_set.pages.find(page_low) < page_set.pages.find(page_high)
	
	func apply(page_set: PageSet) -> bool:
		if not page_set.pages.has(page_low):
			return false
		if not page_set.pages.has(page_high):
			return false
		
		var index_low = page_set.pages.find(page_low)
		var index_high = page_set.pages.find(page_high)
		if index_low < index_high:
			return false
		
		var tmp: int = page_set.pages[index_low]
		page_set.pages[index_low] = page_set.pages[index_high]
		page_set.pages[index_high] = tmp
		page_set.pages
		return true


class PageSet:
	var pages: Array[int]
	
	func get_middle_number() -> int:
		var middle_number = pages.size() / 2
		return pages[middle_number]
