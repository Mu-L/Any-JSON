class_name A2JObjectTypeHandler extends A2JTypeHandler


func _init() -> void:
	error_strings = [
		'Object not defined in registry.',
		'"property_exclusions" in ruleset should be structured as follows: Dictionary[Array[String]].'
	]


func to_json(object:Object, ruleset:Dictionary) -> Dictionary[String,Variant]:
	var object_class: String
	var script:Script = object.get_script()
	if script != null:
		object_class = script.get_global_name()
	else:
		object_class = object.get_class()

	# Get & check registered object equivalent.
	var registered_object = A2J.object_registry.get(object_class, null)
	if registered_object == null:
		report_error(0)
		return {}
	registered_object = registered_object as Object
	var result:Dictionary[String,Variant] = {
		'.type': 'Object:%s' % object_class, 
	}

	# Convert all properties.
	var excluded_properties:Array[String] = _get_excluded_properties(object, ruleset)
	for property in object.get_property_list():
		if property.name in excluded_properties: continue
		var property_value = object.get(property.name)
		# Exclude null values.
		if property_value == null: continue
		# Convert value if not a primitive type.
		var new_value
		if typeof(property_value) not in A2J.primitive_types:
			new_value = A2J.to_json(property_value, ruleset)
			if new_value.get('.primitive', false) == true:
				new_value = new_value.get('value')
		else:
			new_value = property_value
		# Set new value.
		result.set(property.name, new_value)
	
	return result


func from_json(json:Dictionary[String,Variant], ruleset:Dictionary) -> Object:
	var object_class:String = json.get('.type', '')
	assert(object_class.begins_with('Object:'), 'JSON ".type" must be "Object:<class_name>".')
	object_class = object_class.replace('Object:','')
	
	var registered_object = A2J.object_registry.get(object_class, null)
	if registered_object == null:
		report_error(0)
	registered_object = registered_object as Object

	var result:Object = registered_object.new()
	var excluded_properties:Array[String] = _get_excluded_properties(result, ruleset)
	for key in json:
		if key.begins_with('.'): continue
		if key in excluded_properties: continue
		var value = json[key]
		var new_value
		if typeof(value) not in A2J.primitive_types:
			new_value = A2J.from_json(value, ruleset)
			if new_value is Dictionary && new_value.get('.primitive') == true:
				new_value = new_value.get('value')
		else:
			new_value = value
		# Set value as metadata.
		if key.begins_with('metadata/'):
			result.set_meta(key.replace('metadata/',''), new_value)
		# Set value
		else:
			result.set(key, new_value)

	return result



## Assemble list of properties to exclude.
## [param object] is the object to use [code]is_class[/code] on.
func _get_excluded_properties(object:Object, ruleset:Dictionary) -> Array[String]:
	var property_exclusions_in_ruleset:Dictionary = ruleset.get('property_exclusions',{})
	# Throw error if property exclusions is not the expected type.
	if property_exclusions_in_ruleset is not Dictionary:
		report_error(1)
		return []

	# Iterate on every list of exclusions.
	var excluded_properties:Array[String] = []
	for key in property_exclusions_in_ruleset:
		if object.is_class(key):
			var list = property_exclusions_in_ruleset[key]
			# Throw error if value is not the expected type.
			if list is not Array:
				report_error(1)
				return []
			# Add to excluded properties.
			excluded_properties.append_array(list)

	return excluded_properties
