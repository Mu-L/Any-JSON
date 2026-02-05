@tool
extends Node
@export var item: Resource
@export var file_path:String = 'res://examples/compression/output.dat'
@export var compression_mode:FileAccess.CompressionMode = FileAccess.COMPRESSION_GZIP
@export_tool_button('Save compressed') var compress = compress_callback
@export_tool_button('Uncompress & print') var uncompress = uncompress_callback


func compress_callback() -> void:
	print_rich('[color=yellow][b]Converting exported [code]item[/code] variable to AJSON & storing as compressed (%s) file at [code]%s[/code]...' % [compression_mode ,file_path])
	var ruleset := A2J.default_ruleset.duplicate(true)
	ruleset['@global'].automatic_resource_references = false
	# Serialize `item` to stringified AJSON.
	# Converting the dictionary itself to a binary format is tricky & most methods result in significantly more bytes than a JSON string.
	var ajson = JSON.stringify(A2J.to_json(item, ruleset))
	# Open new file with compression mode.
	var file = FileAccess.open_compressed(file_path, FileAccess.WRITE, compression_mode)
	print(error_string(FileAccess.get_open_error()))
	if file == null: return
	# Write our stringified AJSON to the file.
	file.store_string(ajson)
	file.close()
	# Print uncompressed vs compressed results.
	print_rich('[b]Uncompressed byte count:[/b] %s' % ajson.to_utf8_buffer().size())
	print_rich('[b]Compressed byte count:[/b] %s' % FileAccess.get_file_as_bytes(file_path).size())


func uncompress_callback() -> void:
	print_rich('[color=yellow][b]Uncompressing compressed (%s) file at [code]%s[/code]...' % [compression_mode ,file_path])
	var file = FileAccess.open_compressed(file_path, FileAccess.READ, compression_mode)
	print(error_string(FileAccess.get_open_error()))
	if file == null: return
	print_rich('[b]Output:[/b]\n' + JSON.stringify(JSON.parse_string(file.get_as_text()), '\t'))
	file.close()
