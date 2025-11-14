@tool
extends Node

@export_tool_button('Test A2J') var test_a2j = test_a2j_callback


func test_a2j_callback() -> void:
	print_rich('[color=yellow][b]Converting to Any-JSON...')
	# Create example object & assign metadata to it.
	var test_obj := Object.new()
	test_obj.set_meta('example', ['a','b','c', Object.new(), {'1':'uien', '2':9.98, Vector3(0,0,0):100.2}])
	var nested_obj := Object.new()
	test_obj.set_meta('example_nested_object', nested_obj)

	# Convert to json & print result.
	var test_obj_json = A2J.to_json(test_obj)
	print(test_obj_json)

	print_rich('[color=green][b]Converting back to original...')
	# Convert back to an Object & print the metadata.
	var json_to_object:Object = A2J.from_json(test_obj_json)
	print(json_to_object.get_meta('example')) # prints: ['a','b','c']
	print(json_to_object.get_meta('example_nested_object')) # prints: <Object#...>
