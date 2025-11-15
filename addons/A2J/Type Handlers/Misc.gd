## Handles serialization for various types.
## [br][br][b]Types:[/b]
## [br]- StringName
## [br]- NodePath
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

	# Throw error if not an expected type.
	else:
		report_error(0)
		return {}

	return result


func from_json(json:Dictionary, ruleset:Dictionary) -> Variant:
	var values = json.get('values')
	var is_float = json.get('float')
	# Throw error if values is not an Array.
	if values is not Array:
		report_error(1)
		return null
	# Throw error if is_float is not a boolean.
	if is_float is not bool:
		report_error(1)
		return null
	# Re-type variables.
	values = values as Array
	is_float = is_float as bool
	
	# Check & throw error if values contains anything not a number.
	var contains_only_numbers:bool = values.all(func(item) -> bool:
		return item is int or item is float
	)
	if not contains_only_numbers:
		report_error(1)
		return null

	# Vector2.
	if values.size() == 2 && not is_float:
		return Vector2i(values[0], values[1])
	elif values.size() == 2 && is_float:
		return Vector2(values[0], values[1])
	# Vector3.
	elif values.size() == 3 && not is_float:
		return Vector3i(values[0], values[1], values[2])
	elif values.size() == 3 && is_float:
		return Vector3(values[0], values[1], values[2])
	# Vector4.
	elif values.size() == 4 && not is_float:
		return Vector4i(values[0], values[1], values[2], values[3])
	elif values.size() == 4 && is_float:
		return Vector4(values[0], values[1], values[2], values[3])
	# Throw error if no conditions match.
	else:
		report_error(1)
		return null
