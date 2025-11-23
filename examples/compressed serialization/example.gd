@tool
extends Node

@export var item: Resource
@export var file_path:String = 'res://compressed_ajson.dat'
@export var compression_mode:FileAccess.CompressionMode = FileAccess.COMPRESSION_GZIP
@export_tool_button('Save compressed') var compress = compress_callback
@export_tool_button('Uncompress & print') var uncompress = uncompress_callback


func compress_callback() -> void:
	print_rich('[color=yellow][b]Converting exported [code]item[/code] variable to AJSON & storing as compressed (%s) file at [code]%s[/code]...' % [compression_mode ,file_path])
	var ajson = JSON.stringify(A2J.to_json(item))
	var file = FileAccess.open_compressed(file_path, FileAccess.WRITE, compression_mode)
	print(error_string(FileAccess.get_open_error()))
	if file == null: return
	file.store_string(ajson) # Store as a string, this is more size efficient than storing the raw dictionary as a variable in the file, or storing the the string as a var.
	file.close()
	print_rich('[b]Uncompressed byte count:[/b] %s' % var_to_bytes(ajson).size())
	print_rich('[b]Compressed byte count:[/b] %s' % FileAccess.get_file_as_bytes(file_path).size())


func uncompress_callback() -> void:
	print_rich('[color=yellow][b]Uncompressing compressed (%s) file at [code]%s[/code]...' % [compression_mode ,file_path])
	var file = FileAccess.open_compressed(file_path, FileAccess.READ, compression_mode)
	print(error_string(FileAccess.get_open_error()))
	if file == null: return
	var result = JSON.parse_string(file.get_as_text())
	print_rich('[b]Output:[/b] %s' % result)
