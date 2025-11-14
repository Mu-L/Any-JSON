## Only handles
class_name A2JArrayTypeHandler extends A2JTypeHandler


func _init() -> void:
	error_strings = [
		'Cannot call "from_json" with invalid an Any-JSON object. Expects Array or Dictionary.',
	]


func to_json(array:Array, ruleset:Dictionary) -> Dictionary[String,Variant]:
	var result:Dictionary[String,Variant] = {
		'.primitive': true,
		'value': [], 
	}

	# Convert all items.
	for value in array:
		# Convert value if not a primitive type.
		var new_value
		if typeof(value) not in A2J.primitive_types:
			new_value = A2J.to_json(value, ruleset)
			if new_value.get('.primitive') == true:
				new_value = new_value.get('value')
		else:
			new_value = value
		# Set new value.
		result.value.append(new_value)
	
	return result


func from_json(json, ruleset:Dictionary) -> Array:
	var list: Array
	if json is Dictionary:
		list = json.get('value', [])
	if json is Array:
		list = json
	else:
		report_error(0)
		return []

	var result:Array = []
	for item in list:
		var new_value
		if typeof(item) not in A2J.primitive_types:
			new_value = A2J.from_json(item, ruleset)
			if new_value is Dictionary && new_value.get('.primitive') == true:
				new_value = new_value.get('value')
		else:
			new_value = item
		# Append value
		result.append(new_value)

	return result
