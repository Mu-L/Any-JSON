## Handles serialization for various types.
## [br][br][b]Types:[/b]
## [br]- StringName
## [br]- NodePath
## [br]- Color
class_name A2JMiscTypeHandler extends A2JTypeHandler


func _init() -> void:
	error_strings = [
		'Cannot convert invalid value to JSON.',
		'Cannot construct value from invalid JSON representation.',
	]


func to_json(value, ruleset:Dictionary) -> Dictionary[String,Variant]:
	var result:Dictionary[String,Variant] = {
		'.type': type_string(typeof(value)),
		'value': null,
	}

	if value is StringName or value is NodePath:
		result.value = str(value)

	elif value is Color:
		result.value = [value.r, value.g, value.b, value.a]

	# Throw error if not an expected type.
	else:
		report_error(0)
		return {}

	return result


func from_json(json:Dictionary, ruleset:Dictionary) -> Variant:
	var type = json.get('.type')
	if type is not String:
		report_error(1)
		return null
	var value = json.get('value')

	if type == 'StringName':
		if value is not String: report_error(1); return null
		return StringName(value)

	elif type == 'NodePath':
		if value is not String: report_error(1); return null
		return NodePath(value)

	elif type == 'Color':
		if value is not Array or value.size() != 4: report_error(1); return null
		var contains_only_numbers:bool = value.all(func(item) -> bool:
			return item is int or item is float
		)
		if not contains_only_numbers: report_error(1); return null
		return Color(value[0], value[1], value[2], value[3])

	# Throw error if no conditions match.
	else:
		report_error(1)
		return null
