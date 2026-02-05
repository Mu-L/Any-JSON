@tool
extends Node
@export var item: Resource
@export var encryption_file_path:String = 'res://examples/encryption/output.dat'
@export var encryption_passkey:String = 'super secret key'
@export_tool_button('Encrypt file & print') var test_encrypt = test_encrypt_callback
@export_tool_button('Decrypt file & print.') var test_decrypt = test_decrypt_callback


func test_encrypt_callback() -> void:
	print_rich('[color=yellow][b]Encrypting & storing last result to [code]%s[/code] using passkey "%s"...' % [encryption_file_path, encryption_passkey])
	var file = FileAccess.open_encrypted_with_pass(encryption_file_path, FileAccess.WRITE, encryption_passkey)
	print(error_string(FileAccess.get_open_error()))
	file.resize(0)
	if file == null: return
	var ruleset := A2J.default_ruleset.duplicate(true)
	ruleset['@global'].automatic_resource_references = false
	var converted_item = A2J.to_json(item, ruleset)
	file.store_string(JSON.stringify(converted_item))
	file.close()
	print_rich('[b]Output (printing as bytes, file is not UTF-8 compatible):[/b] %s' % FileAccess.get_file_as_bytes(encryption_file_path))


func test_decrypt_callback() -> void:
	print_rich('[color=yellow][b]Decrypting file at [code]%s[/code] using passkey "%s"...' % [encryption_file_path, encryption_passkey])
	var file = FileAccess.open_encrypted_with_pass(encryption_file_path, FileAccess.READ, encryption_passkey)
	print(error_string(FileAccess.get_open_error()))
	if file == null: return
	print_rich('[b]Output:[/b]\n' + JSON.stringify(JSON.parse_string(file.get_as_text()), '\t'))
	file.close()
