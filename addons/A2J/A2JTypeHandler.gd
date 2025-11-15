@abstract class_name A2JTypeHandler extends RefCounted

## Convert a value to an AJSON object. Can connect to [code]A2J.to_json[/code] for recursion.
@abstract func to_json(value, ruleset:Dictionary)
## Convert an AJSON object back into the original item. Can connect to [code]A2J.from_json[/code] for recursion.
@abstract func from_json(value, ruleset:Dictionary)

const a2jError := 'A2J Error: '
var print_errors := true
var error_strings = []
var error_stack:Array[int] = []


## Report an error to Any-JSON.
## [param translations] should be strings.
func report_error(error:int, ...translations) -> void:
	error_stack.append(error)
	if print_errors:
		var message = error_strings.get(error)
		if not message:
			printerr(a2jError+str(error))

		else:
			var translated_message = message
			for tr in translations:
				if tr is String:
					translated_message = translated_message.replace('~~', tr)
			printerr(a2jError+translated_message)
