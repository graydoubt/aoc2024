class_name AOC2024Day5Part1 extends CanvasLayer

## Advent of Code 2024 - Day 5 - Part 1
##
## Please see the problem description:
## [url=https://adventofcode.com/2024/day/5]Day 5: Print Queue[/url]
## [br]
## [br]
## My solution takes this approach:[br]
## - Read the input into "order rules" and "pages"
## - Validate the pages against the order rules
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
	
	var valid_pages = page_sets.filter(
		func(page_set: PageSet) -> bool:
			for rule in ordering_rules:
				if not rule.is_valid(page_set):
					return false
			return true
	)
	
	print("%d pages are valid." % [valid_pages.size()])
	
	var middle_page_summation: int = 0
	
	for page: PageSet in valid_pages:
		middle_page_summation += page.get_middle_number()
	
	var result: String = "All correctly-ordered middle pages add up to %d." % [middle_page_summation]
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
		

class PageSet:
	var pages: Array[int]
	
	func get_middle_number() -> int:
		var middle_number = pages.size() / 2
		return pages[middle_number]
