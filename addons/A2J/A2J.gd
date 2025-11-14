@tool
## Main API for Anything to JSON.
## Call [code]init[/code] before using!
class_name A2J extends RefCounted

const primitive_types:Array[Variant.Type] = [
	TYPE_BOOL,
	TYPE_INT,
	TYPE_FLOAT,
	TYPE_STRING,
]

const default_ruleset_to := {
	'allowed_types': [
		'Object',
		'NonStandardDict',
		'Callable',
	],
	'property_exclusions': {
		# Exclude all resource properties when converting to Any-JSON.
		'Resource': [
			'resource_local_to_scene',
			'resource_path',
			'resource_name',
			'resource_scene_unique_id',
			'resource_priority',
		],
	},
}

const default_ruleset_from := {
	'allowed_types': default_ruleset_to.allowed_types,
	'property_exclusions': {
		# Exclude all resource properties when converting from Any-JSON.
		'Resource': default_ruleset_to.property_exclusions.Resource,
	},
}

const no_handler_error := 'No handler implemented for type "%s". Make a handler with the abstract A2JTypeHandler class.'


## A2JTypeHandlers that can be used.
## You can add custom type handlers here.
static var type_handlers:Dictionary[String,A2JTypeHandler] = {
	'Object': A2JObjectTypeHandler.new(),
	'Array': A2JArrayTypeHandler.new(),
	'Dictionary': A2JDictionaryTypeHandler.new(),
}

## Set of recognized objects used for conversion to & from Any-JSON.
## You can safely add or remove objects from this registry as you see fit.
## [br][br]
## Is equipped with many (but not all) built-in Godot classes by default.
static var object_registry:Dictionary[StringName,Object] = {
	'Object':Object, 'RefCounted':RefCounted, 'Resource':Resource, 'Script':Script, 'GDScript':GDScript, 'GDExtension':GDExtension,
	# Shader.
	'Shader':Shader, 'ShaderInclude':ShaderInclude, 'VisualShader':VisualShader, 'VisualShaderNode':VisualShaderNode,
	# Texture.
	'Texture':Texture, 'Texture2D':Texture2D, 'AnimatedTexture':AnimatedTexture, 'AtlasTexture':AtlasTexture, 'CameraTexture':CameraTexture, 'CanvasTexture':CanvasTexture, 'CompressedTexture2D':CompressedTexture2D, 'CurveTexture':CurveTexture, 'CurveXYZTexture':CurveXYZTexture, 'DPITexture':DPITexture, 'ExternalTexture':ExternalTexture, 'GradientTexture1D':GradientTexture1D, 'GradientTexture2D':GradientTexture2D, 'ImageTexture':ImageTexture, 'ImageTexture3D':ImageTexture3D, 'MeshTexture':MeshTexture, 'NoiseTexture2D':NoiseTexture2D, 'NoiseTexture3D':NoiseTexture3D, 'PlaceholderTexture2D':PlaceholderTexture2D, 'ViewportTexture':ViewportTexture,
	# Animation.
	'Animation':Animation, 'AnimationLibrary':AnimationLibrary, 'AnimationNode':AnimationNode, 'AnimationNodeAdd2':AnimationNodeAdd2, 'AnimationNodeAdd3':AnimationNodeAdd3, 'AnimationNodeAnimation':AnimationNodeAnimation, 'AnimationNodeBlend2':AnimationNodeBlend2, 'AnimationNodeBlend3':AnimationNodeBlend3, 'AnimationNodeBlendSpace1D':AnimationNodeBlendSpace1D, 'AnimationNodeBlendSpace2D':AnimationNodeBlendSpace2D, 'AnimationNodeBlendTree':AnimationNodeBlendTree, 'AnimationNodeExtension':AnimationNodeExtension, 'AnimationNodeOneShot':AnimationNodeOneShot, 'AnimationNodeOutput':AnimationNodeOutput, 'AnimationNodeStateMachine':AnimationNodeStateMachine,
	# Mesh.
	'Mesh':Mesh, 'ArrayMesh':ArrayMesh, 'PrimitiveMesh':PrimitiveMesh, 'BoxMesh':BoxMesh, 'CapsuleMesh':CapsuleMesh, 'CylinderMesh':CylinderMesh, 'PlaneMesh':PlaneMesh, 'QuadMesh':QuadMesh, 'PointMesh':PointMesh, 'PrismMesh':PrismMesh, 'RibbonTrailMesh':RibbonTrailMesh, 'SphereMesh':SphereMesh, 'TextMesh':TextMesh, 'TorusMesh':TorusMesh, 'TubeTrailMesh':TubeTrailMesh, 'PlaceholderMesh':PlaceholderMesh, 'ImmediateMesh':ImmediateMesh,
	# Material.
	'Material':Material, 'ShaderMaterial':ShaderMaterial, 'BaseMaterial3D':BaseMaterial3D, 'StandardMaterial3D':StandardMaterial3D, 'ORMMaterial3D':ORMMaterial3D, 'FogMaterial':FogMaterial,
	# Occluder3D.
	'Occluder3D':Occluder3D, 'ArrayOccluder3D':ArrayOccluder3D, 'BoxOccluder3D':BoxOccluder3D, 'PolygonOccluder3D':PolygonOccluder3D, 'QuadOccluder3D':QuadOccluder3D, 'SphereOccluder3D':SphereOccluder3D,
	# AudioBusLayout / AudioEffect.
	'AudioBusLayout':AudioBusLayout, 'AudioEffect':AudioEffect, 'AudioEffectAmplify':AudioEffectAmplify, 'AudioEffectChorus':AudioEffectChorus, 'AudioEffectCompressor':AudioEffectCompressor, 'AudioEffectDelay':AudioEffectDelay, 'AudioEffectDistortion':AudioEffectDistortion, 'AudioEffectReverb':AudioEffectReverb, 'AudioEffectPhaser':AudioEffectPhaser, 'AudioEffectFilter':AudioEffectFilter,
	# AudioStream.
	'AudioStream':AudioStream, 'AudioStreamGenerator':AudioStreamGenerator, 'AudioStreamGeneratorPlayback':AudioStreamGeneratorPlayback, 'AudioStreamInteractive':AudioStreamInteractive, 'AudioStreamMicrophone':AudioStreamMicrophone, 'AudioStreamMP3':AudioStreamMP3, 'AudioStreamOggVorbis':AudioStreamOggVorbis, 'AudioStreamPlayback':AudioStreamPlayback, 'AudioStreamPlaybackInteractive':AudioStreamPlaybackInteractive, 'AudioStreamPlaybackOggVorbis':AudioStreamPlaybackOggVorbis, 'AudioStreamPlaybackPlaylist':AudioStreamPlaybackPlaylist, 'AudioStreamPlaybackPolyphonic':AudioStreamPlaybackPolyphonic, 'AudioStreamPlaybackResampled':AudioStreamPlaybackResampled, 'AudioStreamPlaybackSynchronized':AudioStreamPlaybackSynchronized,
	# Shape2D.
	'Shape2D':Shape2D, 'CapsuleShape2D':CapsuleShape2D, 'CircleShape2D':CircleShape2D, 'ConcavePolygonShape2D':ConcavePolygonShape2D, 'ConvexPolygonShape2D':ConvexPolygonShape2D, 'RectangleShape2D':RectangleShape2D, 'SegmentShape2D':SegmentShape2D, 'SeparationRayShape2D':SeparationRayShape2D, 'WorldBoundaryShape2D':WorldBoundaryShape2D,
	# Shape3D.
	'BoxShape3D':BoxShape3D, 'CapsuleShape3D':CapsuleShape3D, 'ConcavePolygonShape3D':ConcavePolygonShape3D, 'ConvexPolygonShape3D':ConvexPolygonShape3D, 'CylinderShape3D':CylinderShape3D, 'HeightMapShape3D':HeightMapShape3D, 'SeparationRayShape3D':SeparationRayShape3D, 'SphereShape3D':SphereShape3D, 'WorldBoundaryShape3D':WorldBoundaryShape3D,
	# Misc.
	'BitMap':BitMap, 'BoneMap':BoneMap, 'Theme':Theme, 'ThemeDB':ThemeDB, 'Curve':Curve, 'Curve2D':Curve2D, 'Curve3D':Curve3D, 'CameraAttributes':CameraAttributes, 'CameraAttributesPhysical':CameraAttributesPhysical, 'CameraAttributesPractical':CameraAttributesPractical,
	# Node.
	'Node':Node, 'Control':Control, 'Node2D':Node2D, 'Node3D':Node3D, 'Camera2D':Camera2D, 'Camera3D':Camera3D, 'AudioStreamPlayer2D':AudioStreamPlayer2D, 'AudioStreamPlayer3D':AudioStreamPlayer3D,
}


## Convert [param value] to an Any-JSON object. Only objects in the Object Registry can be converted.
static func to_json(value:Variant, ruleset=default_ruleset_to) -> Dictionary[String,Variant]:
	var type := type_string(typeof(value))
	if type == 'Dictionary':
		type = value.get('.type', '').split(':')[0]
		if type == '': type = 'Dictionary'

	var handler = type_handlers.get(type, null)
	if handler == null:
		printerr(no_handler_error % type)
		return {}
	handler = handler as A2JTypeHandler

	return handler.to_json(value, ruleset)


## Convert [param value] to it's original object.
## [param value] should be Dictionary or Array.
static func from_json(value, ruleset=default_ruleset_from) -> Variant:
	var type: String
	var handler

	if value is Dictionary:
		type = value.get('.type', '').split(':')[0]
		if type == '': type = 'Dictionary'

	elif value is Array:
		type = 'Array'

	handler = type_handlers.get(type, null)
	if handler == null:
		printerr(no_handler_error % type)
		return null
	handler = handler as A2JTypeHandler

	return handler.from_json(value, ruleset)
