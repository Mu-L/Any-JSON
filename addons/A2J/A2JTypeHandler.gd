@abstract class_name A2JTypeHandler extends RefCounted

## Convert a value to an Any-JSON object. Can connect to [code]A2J.to_json[/code] for recursion.
@abstract func to_json(value, ruleset:Dictionary) -> Dictionary[String,Variant]
## Convert an Any-JSON object back into the original item. Can connect to [code]A2J.from_json[/code] for recursion.
@abstract func from_json(value, ruleset:Dictionary)

const a2jError := 'A2J Error: '
var push_errors := true
var error_strings = []
var error_stack:Array[int] = []


func report_error(error:int) -> void:
	error_stack.append(error)
	if push_errors:
		var message = error_strings.get(error)
		if not message:
			printerr(a2jError+str(error))
		else:
			printerr(a2jError+message)
