## Only handles
class_name A2JDictionaryTypeHandler extends A2JTypeHandler


func _init() -> void:
	error_strings = [
		'Cannot convert a Dictionary with keys not of type String. Support may be added in a later version.',
	]


func to_json(dict:Dictionary, ruleset:Dictionary) -> Dictionary[String,Variant]:
	var result:Dictionary[String,Variant] = {
		'.primitive': true,
		'value': {},
	}
	var non_standard_keys

	# Convert all items.
	for key in dict:
		# Throw error if key is not standard.
		if key is not String:
			report_error(0)
			return {}
		var value = dict[key]
		# Convert value if not a primitive type.
		var new_value
		if typeof(value) not in A2J.primitive_types:
			new_value = A2J.to_json(value, ruleset)
			if new_value.get('.primitive') == true:
				new_value = new_value.get('value')
		else:
			new_value = value
		# Set new value.
		result.value.set(key, new_value)
	
	return result


func from_json(json, ruleset:Dictionary) -> Dictionary:
	var result := {}
	for key in json:
		var value = json[key]
		var new_value
		if typeof(value) not in A2J.primitive_types:
			new_value = A2J.from_json(value, ruleset)
			if new_value is Dictionary && new_value.get('.primitive') == true:
				new_value = new_value.get('value')
		else:
			new_value = value
		# Append value
		result.set(key, new_value)

	return result
