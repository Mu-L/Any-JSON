@tool
## Main API for the Any-JSON plugin.
class_name A2J extends RefCounted

enum State {
	IDLE,
	SERIALIZING,
	DESERIALIZING,
}

## Primitive types that do not require handlers.
const primitive_types:Array[Variant.Type] = [
	TYPE_NIL,
	TYPE_BOOL,
	TYPE_INT,
	TYPE_FLOAT,
	TYPE_STRING,
]

## The default ruleset used when serializing or deserializing.
const default_ruleset:Dictionary[String,Dictionary] = {
	# Rules applied everywhere.
	'@global': {
		'type_exclusions': [
			'RID',
			'Signal',
			'Callable',
		],
		'type_inclusions': [],
		'class_exclusions': [],
		'class_inclusions': [],
		'exclude_private_properties': true,
		'exclude_default_properties': true,
		'automatic_resource_references': true,
	},
	# Rules applied only to the [class Resource] class.
	'Resource': {
		'property_exclusions': [
			'resource_local_to_scene',
			'resource_path',
			'resource_name',
			'resource_scene_unique_id',
			'resource_priority',
		],
	}
}

const error_strings:PackedStringArray = [
	'No handler implemented for type "~~". Make a handler with the abstract A2JTypeHandler class.',
	'"type_exclusions" & "type_inclusions" in ruleset should be structured as follows: Array[String].',
	'"class_exclusions" & "class_inclusions" in ruleset should be structured as follows: Array[String].',
]


# Template for instantiator function.
static func _default_instantiator_function(registered_object:Object, _object_class:StringName, args:Array=[]) -> Object:
	return registered_object.callv('new', args)


static var _vector_type_handler := A2JVectorTypeHandler.new()
static var _packed_array_type_handler := A2JPackedArrayTypeHandler.new()
static var _misc_type_handler := A2JMiscTypeHandler.new()
static var _object_type_handler := A2JObjectTypeHandler.new()
static var _array_type_handler := A2JArrayTypeHandler.new()
static var _dictionary_type_handler := A2JDictionaryTypeHandler.new()
## A2JTypeHandlers that can be used.
## You can add custom type handlers here.
static var type_handlers:Dictionary[String,A2JTypeHandler] = {
	'A2JRef':A2JReferenceTypeHandler.new(),
	'Obj':_object_type_handler, 'Object':_object_type_handler,
	'Array':_array_type_handler,
	'Dictionary':_dictionary_type_handler,
	'Vector':_vector_type_handler, 'VectorI':_vector_type_handler, 'Vector2':_vector_type_handler, 'Vector2i':_vector_type_handler,
	'Vector3':_vector_type_handler, 'Vector3i':_vector_type_handler,
	'Vector4':_vector_type_handler, 'Vector4i':_vector_type_handler,
	'PackedByteArray':_packed_array_type_handler,
	'PackedInt32Array':_packed_array_type_handler, 'PackedInt64Array':_packed_array_type_handler,
	'PackedFloat32Array':_packed_array_type_handler, 'PackedFloat64Array':_packed_array_type_handler,
	'PackedVector2Array':_packed_array_type_handler, 'PackedVector3Array':_packed_array_type_handler, 'PackedVector4Array':_packed_array_type_handler,
	'PackedColorArray':_packed_array_type_handler,
	'PackedStringArray':_packed_array_type_handler,
	'StringName':_misc_type_handler,
	'NodePath':_misc_type_handler,
	'Color':_misc_type_handler,
	'Plane':_misc_type_handler,
	'Quaternion':_misc_type_handler,
	'Rect2':_misc_type_handler, 'Rect2i':_misc_type_handler,
	'AABB':_misc_type_handler,
	'Basis':_misc_type_handler,
	'Transform2D':_misc_type_handler, 'Transform3D':_misc_type_handler,
	'Projection':_misc_type_handler,
}

## Set of recognized classes used for conversion to & from AJSON.
## You can safely add or remove classes from this registry as you see fit.
## [br][br]
## Is, by default; equipped with many but not all built-in Godot classes.
## [br]
## This also means if your game export excludes certain classes you may need to remove them from here.
static var object_registry:Dictionary[StringName,Object] = {
	'ZIPReader':ZIPReader, 'ZIPPacker':ZIPPacker, 'Window':Window, 'WebSocketPeer':WebSocketPeer, 'WebSocketMultiplayerPeer':WebSocketMultiplayerPeer, 
	'WebRTCPeerConnection':WebRTCPeerConnection, 'WebRTCMultiplayerPeer':WebRTCMultiplayerPeer, 'UPNPDevice':UPNPDevice, 'UPNP':UPNP, 'Tree':Tree, 
	'TileSetScenesCollectionSource':TileSetScenesCollectionSource, 'TileSetAtlasSource':TileSetAtlasSource, 'TileSet':TileSet, 'TileMapPattern':TileMapPattern, 'TileMapLayer':TileMapLayer, 
	'TileMap':TileMap, 'Texture2D':Texture2D, 'TextParagraph':TextParagraph, 'TextLine':TextLine, 'TextEdit':TextEdit, 
	'SurfaceTool':SurfaceTool, 'SpriteFrames':SpriteFrames, 'Skeleton3D':Skeleton3D, 'Shader':Shader, 'ScriptCreateDialog':ScriptCreateDialog, 
	'SceneTree':SceneTree, 'SceneReplicationConfig':SceneReplicationConfig, 'SceneMultiplayer':SceneMultiplayer, 'RigidBody3D':RigidBody3D, 'RigidBody2D':RigidBody2D, 
	'RichTextLabel':RichTextLabel, 'ResourceSaver':ResourceSaver, 'ResourceLoader':ResourceLoader, 'RegEx':RegEx, 'ProjectSettings':ProjectSettings, 
	'PortableCompressedTexture2D':PortableCompressedTexture2D, 'PopupMenu':PopupMenu, 'PhysicsRayQueryParameters3D':PhysicsRayQueryParameters3D, 'PhysicsRayQueryParameters2D':PhysicsRayQueryParameters2D, 'PhysicalBone3D':PhysicalBone3D, 
	'Performance':Performance, 'OptionButton':OptionButton, 'Node3D':Node3D, 'Node':Node, 'NavigationMeshGenerator':NavigationMeshGenerator, 
	'NativeMenu':NativeMenu, 'Line2D':Line2D, 'ItemList':ItemList, 'InputMap':InputMap, 'ImporterMesh':ImporterMesh, 
	'ImmediateMesh':ImmediateMesh, 'HTTPRequest':HTTPRequest, 'GridMap':GridMap, 'GraphNode':GraphNode, 'Geometry3D':Geometry3D, 
	'Geometry2D':Geometry2D, 'FileDialog':FileDialog, 'Expression':Expression, 'EngineDebugger':EngineDebugger, 'ENetMultiplayerPeer':ENetMultiplayerPeer, 
	'ENetConnection':ENetConnection, 'Curve3D':Curve3D, 'Curve2D':Curve2D, 'Curve':Curve, 'Control':Control, 
	'CodeEdit':CodeEdit, 'BitMap':BitMap, 'ArrayMesh':ArrayMesh, 'AnimationPlayer':AnimationPlayer, 'Animation':Animation, 
	'AnimatedSprite3D':AnimatedSprite3D, 'AnimatedSprite2D':AnimatedSprite2D, 'AcceptDialog':AcceptDialog, 'EngineProfiler':EngineProfiler, 'ImageFormatLoaderExtension':ImageFormatLoaderExtension, 
	'PackedDataContainer':PackedDataContainer, 'RandomNumberGenerator':RandomNumberGenerator, 'EncodedObjectAsID':EncodedObjectAsID, 'AStarGrid2D':AStarGrid2D, 'AStar2D':AStar2D, 
	'AStar3D':AStar3D, 'PCKPacker':PCKPacker, 'ConfigFile':ConfigFile, 'JSON':JSON, 'XMLParser':XMLParser, 
	'Logger':Logger, 'Semaphore':Semaphore, 'Mutex':Mutex, 'Thread':Thread, 'TriangleMesh':TriangleMesh, 
	'UndoRedo':UndoRedo, 'OptimizedTranslation':OptimizedTranslation, 'TranslationDomain':TranslationDomain, 'Translation':Translation, 'MainLoop':MainLoop, 
	'DTLSServer':DTLSServer, 'PacketPeerDTLS':PacketPeerDTLS, 'StreamPeerTLS':StreamPeerTLS, 'Crypto':Crypto, 'CryptoKey':CryptoKey, 
	'X509Certificate':X509Certificate, 'AESContext':AESContext, 'HashingContext':HashingContext, 'HTTPClient':HTTPClient, 'UDPServer':UDPServer, 
	'PacketPeerUDP':PacketPeerUDP, 'PacketPeerStream':PacketPeerStream, 'PacketPeerExtension':PacketPeerExtension, 'UDSServer':UDSServer, 'StreamPeerUDS':StreamPeerUDS, 
	'TCPServer':TCPServer, 'StreamPeerTCP':StreamPeerTCP, 'StreamPeerGZIP':StreamPeerGZIP, 'StreamPeerBuffer':StreamPeerBuffer, 'StreamPeerExtension':StreamPeerExtension, 
	'InputEventMIDI':InputEventMIDI, 'InputEventPanGesture':InputEventPanGesture, 'InputEventMagnifyGesture':InputEventMagnifyGesture, 'InputEventAction':InputEventAction, 'InputEventScreenTouch':InputEventScreenTouch, 
	'InputEventScreenDrag':InputEventScreenDrag, 'InputEventJoypadMotion':InputEventJoypadMotion, 'InputEventJoypadButton':InputEventJoypadButton, 'InputEventMouseMotion':InputEventMouseMotion, 'InputEventMouseButton':InputEventMouseButton, 
	'InputEventShortcut':InputEventShortcut, 'InputEventKey':InputEventKey, 'Shortcut':Shortcut, 'Image':Image, 'MissingResource':MissingResource, 
	'ResourceFormatSaver':ResourceFormatSaver, 'ResourceFormatLoader':ResourceFormatLoader, 'Time':Time, 'Resource':Resource, 'WeakRef':WeakRef, 
	'RefCounted':RefCounted, 'Object':Object, 'NavigationServer3DManager':NavigationServer3DManager, 'NavigationServer2DManager':NavigationServer2DManager, 'PhysicsServer2DManager':PhysicsServer2DManager, 
	'PhysicsServer3DManager':PhysicsServer3DManager, 'TextServerDummy':TextServerDummy, 'TextServerExtension':TextServerExtension, 'PlaceholderMaterial':PlaceholderMaterial, 'Material':Material, 
	'Texture':Texture, 'MissingNode':MissingNode, 'StyleBox':StyleBox, 'TextServerAdvanced':TextServerAdvanced, 'GDScript':GDScript, 
	'PhysicsPointQueryParameters3D':PhysicsPointQueryParameters3D, 'PhysicsDirectSpaceState3DExtension':PhysicsDirectSpaceState3DExtension, 'PhysicsDirectBodyState3DExtension':PhysicsDirectBodyState3DExtension, 'PhysicsServer3DExtension':PhysicsServer3DExtension, 'NavigationPathQueryResult3D':NavigationPathQueryResult3D, 
	'NavigationPathQueryParameters3D':NavigationPathQueryParameters3D, 'PhysicsPointQueryParameters2D':PhysicsPointQueryParameters2D, 'PhysicsDirectSpaceState2DExtension':PhysicsDirectSpaceState2DExtension, 'PhysicsDirectBodyState2DExtension':PhysicsDirectBodyState2DExtension, 'PhysicsServer2DExtension':PhysicsServer2DExtension, 
	'NavigationPathQueryResult2D':NavigationPathQueryResult2D, 'NavigationPathQueryParameters2D':NavigationPathQueryParameters2D, 'MovieWriter':MovieWriter, 'CameraFeed':CameraFeed, 'UniformSetCacheRD':UniformSetCacheRD, 
	'RenderSceneBuffersRD':RenderSceneBuffersRD, 'RenderSceneBuffersExtension':RenderSceneBuffersExtension, 'RenderSceneBuffersConfiguration':RenderSceneBuffersConfiguration, 'RenderSceneDataRD':RenderSceneDataRD, 'RenderSceneDataExtension':RenderSceneDataExtension, 
	'RenderDataRD':RenderDataRD, 'RenderDataExtension':RenderDataExtension, 'AnimationTree':AnimationTree, 'SubtweenTweener':SubtweenTweener, 'MethodTweener':MethodTweener, 
	'CallbackTweener':CallbackTweener, 'IntervalTweener':IntervalTweener, 'PropertyTweener':PropertyTweener, 'Tween':Tween, 'FoldableContainer':FoldableContainer, 
	'FoldableGroup':FoldableGroup, 'GraphEdit':GraphEdit, 'GraphFrame':GraphFrame, 'GraphElement':GraphElement, 'VSplitContainer':VSplitContainer, 
	'HSplitContainer':HSplitContainer, 'SplitContainer':SplitContainer, 'SubViewportContainer':SubViewportContainer, 'CharFXTransform':CharFXTransform, 'RichTextEffect':RichTextEffect, 
	'ColorPickerButton':ColorPickerButton, 'ColorPicker':ColorPicker, 'SpinBox':SpinBox, 'MenuButton':MenuButton, 'MenuBar':MenuBar, 
	'CodeHighlighter':CodeHighlighter, 'SyntaxHighlighter':SyntaxHighlighter, 'ConfirmationDialog':ConfirmationDialog, 'LineEdit':LineEdit, 'TextureProgressBar':TextureProgressBar, 
	'MarginContainer':MarginContainer, 'VFlowContainer':VFlowContainer, 'HFlowContainer':HFlowContainer, 'FlowContainer':FlowContainer, 'PanelContainer':PanelContainer, 
	'ScrollContainer':ScrollContainer, 'CenterContainer':CenterContainer, 'GridContainer':GridContainer, 'VBoxContainer':VBoxContainer, 'HBoxContainer':HBoxContainer, 
	'BoxContainer':BoxContainer, 'TextureButton':TextureButton, 'VSeparator':VSeparator, 'HSeparator':HSeparator, 'TabBar':TabBar, 
	'TabContainer':TabContainer, 'AspectRatioContainer':AspectRatioContainer, 'ReferenceRect':ReferenceRect, 'NinePatchRect':NinePatchRect, 'ColorRect':ColorRect, 
	'TextureRect':TextureRect, 'Container':Container, 'Panel':Panel, 'LinkButton':LinkButton, 'CheckButton':CheckButton, 
	'CheckBox':CheckBox, 'PopupPanel':PopupPanel, 'Popup':Popup, 'VSlider':VSlider, 'HSlider':HSlider, 
	'ProgressBar':ProgressBar, 'VScrollBar':VScrollBar, 'HScrollBar':HScrollBar, 'Range':Range, 'LabelSettings':LabelSettings, 
	'Label':Label, 'Button':Button, 'ButtonGroup':ButtonGroup, 'BaseButton':BaseButton, 'StatusIndicator':StatusIndicator, 
	'Theme':Theme, 'ResourcePreloader':ResourcePreloader, 'CanvasLayer':CanvasLayer, 'Timer':Timer, 'MultiplayerAPIExtension':MultiplayerAPIExtension, 
	'MultiplayerPeerExtension':MultiplayerPeerExtension, 'CompositorEffect':CompositorEffect, 'ViewportTexture':ViewportTexture, 'SubViewport':SubViewport, 'World2D':World2D, 
	'World3D':World3D, 'SkeletonModification2DTwoBoneIK':SkeletonModification2DTwoBoneIK, 'SkeletonModification2DFABRIK':SkeletonModification2DFABRIK, 'SkeletonModification2DCCDIK':SkeletonModification2DCCDIK, 'SkeletonModification2DLookAt':SkeletonModification2DLookAt, 
	'SkeletonModification2D':SkeletonModification2D, 'SkeletonModificationStack2D':SkeletonModificationStack2D, 'ParallaxLayer':ParallaxLayer, 'ParallaxBackground':ParallaxBackground, 'RemoteTransform2D':RemoteTransform2D, 
	'Parallax2D':Parallax2D, 'TileData':TileData, 'TouchScreenButton':TouchScreenButton, 'DampedSpringJoint2D':DampedSpringJoint2D, 'GrooveJoint2D':GrooveJoint2D, 
	'PinJoint2D':PinJoint2D, 'Camera2D':Camera2D, 'CanvasModulate':CanvasModulate, 'BackBufferCopy':BackBufferCopy, 'OccluderPolygon2D':OccluderPolygon2D, 
	'LightOccluder2D':LightOccluder2D, 'DirectionalLight2D':DirectionalLight2D, 'PointLight2D':PointLight2D, 'Bone2D':Bone2D, 'Skeleton2D':Skeleton2D, 
	'Polygon2D':Polygon2D, 'VisibleOnScreenEnabler2D':VisibleOnScreenEnabler2D, 'VisibleOnScreenNotifier2D':VisibleOnScreenNotifier2D, 'ShapeCast2D':ShapeCast2D, 'RayCast2D':RayCast2D, 
	'CollisionPolygon2D':CollisionPolygon2D, 'CollisionShape2D':CollisionShape2D, 'Area2D':Area2D, 'KinematicCollision2D':KinematicCollision2D, 'CharacterBody2D':CharacterBody2D, 
	'AnimatableBody2D':AnimatableBody2D, 'StaticBody2D':StaticBody2D, 'MultiMeshInstance2D':MultiMeshInstance2D, 'MeshInstance2D':MeshInstance2D, 'Marker2D':Marker2D, 
	'Sprite2D':Sprite2D, 'GPUParticles2D':GPUParticles2D, 'CPUParticles2D':CPUParticles2D, 'CanvasGroup':CanvasGroup, 'Node2D':Node2D, 
	'CanvasItemMaterial':CanvasItemMaterial, 'CanvasTexture':CanvasTexture, 'ShaderMaterial':ShaderMaterial, 'CurveXYZTexture':CurveXYZTexture, 'CurveTexture':CurveTexture, 
	'ShaderInclude':ShaderInclude, 'VisualShader':VisualShader, 'NavigationLink3D':NavigationLink3D, 'NavigationObstacle3D':NavigationObstacle3D, 'NavigationAgent3D':NavigationAgent3D, 
	'NavigationMesh':NavigationMesh, 'NavigationRegion3D':NavigationRegion3D, 'NavigationMeshSourceGeometryData3D':NavigationMeshSourceGeometryData3D, 'Generic6DOFJoint3D':Generic6DOFJoint3D, 'ConeTwistJoint3D':ConeTwistJoint3D, 
	'SliderJoint3D':SliderJoint3D, 'HingeJoint3D':HingeJoint3D, 'PinJoint3D':PinJoint3D, 'RemoteTransform3D':RemoteTransform3D, 'FogMaterial':FogMaterial, 
	'FogVolume':FogVolume, 'WorldEnvironment':WorldEnvironment, 'VisibleOnScreenEnabler3D':VisibleOnScreenEnabler3D, 'VisibleOnScreenNotifier3D':VisibleOnScreenNotifier3D, 'PathFollow3D':PathFollow3D, 
	'Path3D':Path3D, 'MultiMesh':MultiMesh, 'MultiMeshInstance3D':MultiMeshInstance3D, 'ShapeCast3D':ShapeCast3D, 'RayCast3D':RayCast3D, 
	'CollisionPolygon3D':CollisionPolygon3D, 'CollisionShape3D':CollisionShape3D, 'Area3D':Area3D, 'VehicleWheel3D':VehicleWheel3D, 'VehicleBody3D':VehicleBody3D, 
	'SkeletonIK3D':SkeletonIK3D, 'LookAtModifier3D':LookAtModifier3D, 'BoneAttachment3D':BoneAttachment3D, 'SoftBody3D':SoftBody3D, 'PhysicalBoneSimulator3D':PhysicalBoneSimulator3D, 
	'SpringArm3D':SpringArm3D, 'CharacterBody3D':CharacterBody3D, 'KinematicCollision3D':KinematicCollision3D, 'AnimatableBody3D':AnimatableBody3D, 'PhysicsMaterial':PhysicsMaterial, 
	'StaticBody3D':StaticBody3D, 'BoneTwistDisperser3D':BoneTwistDisperser3D, 'LimitAngularVelocityModifier3D':LimitAngularVelocityModifier3D, 'JacobianIK3D':JacobianIK3D, 'CCDIK3D':CCDIK3D, 
	'FABRIK3D':FABRIK3D, 'SplineIK3D':SplineIK3D, 'TwoBoneIK3D':TwoBoneIK3D, 'AimModifier3D':AimModifier3D, 'ConvertTransformModifier3D':ConvertTransformModifier3D, 
	'CopyTransformModifier3D':CopyTransformModifier3D, 'BoneConstraint3D':BoneConstraint3D, 'SpringBoneCollisionPlane3D':SpringBoneCollisionPlane3D, 'SpringBoneCollisionCapsule3D':SpringBoneCollisionCapsule3D, 'SpringBoneCollisionSphere3D':SpringBoneCollisionSphere3D, 
	'SpringBoneCollision3D':SpringBoneCollision3D, 'SpringBoneSimulator3D':SpringBoneSimulator3D, 'JointLimitationCone3D':JointLimitationCone3D, 'JointLimitation3D':JointLimitation3D, 'SkeletonProfile':SkeletonProfile, 
	'RetargetModifier3D':RetargetModifier3D, 'ModifierBoneTarget3D':ModifierBoneTarget3D, 'SkeletonModifier3D':SkeletonModifier3D, 'RootMotionView':RootMotionView, 'Marker3D':Marker3D, 
	'Gradient':Gradient, 'CPUParticles3D':CPUParticles3D, 'GPUParticlesAttractorVectorField3D':GPUParticlesAttractorVectorField3D, 'GPUParticlesAttractorSphere3D':GPUParticlesAttractorSphere3D, 'GPUParticlesAttractorBox3D':GPUParticlesAttractorBox3D, 
	'GPUParticlesCollisionHeightField3D':GPUParticlesCollisionHeightField3D, 'Texture3D':Texture3D, 'GPUParticlesCollisionSDF3D':GPUParticlesCollisionSDF3D, 'GPUParticlesCollisionSphere3D':GPUParticlesCollisionSphere3D, 'GPUParticlesCollisionBox3D':GPUParticlesCollisionBox3D, 
	'GPUParticles3D':GPUParticles3D, 'LightmapProbe':LightmapProbe, 'TextureLayered':TextureLayered, 'LightmapGIData':LightmapGIData, 'Sky':Sky, 
	'LightmapGI':LightmapGI, 'VoxelGIData':VoxelGIData, 'VoxelGI':VoxelGI, 'Decal':Decal, 'ReflectionProbe':ReflectionProbe, 
	'SpotLight3D':SpotLight3D, 'OmniLight3D':OmniLight3D, 'DirectionalLight3D':DirectionalLight3D, 'Label3D':Label3D, 'Sprite3D':Sprite3D, 
	'PolygonOccluder3D':PolygonOccluder3D, 'SphereOccluder3D':SphereOccluder3D, 'BoxOccluder3D':BoxOccluder3D, 'QuadOccluder3D':QuadOccluder3D, 'ArrayOccluder3D':ArrayOccluder3D, 
	'OccluderInstance3D':OccluderInstance3D, 'Mesh':Mesh, 'MeshInstance3D':MeshInstance3D, 'Compositor':Compositor, 'Environment':Environment, 
	'Camera3D':Camera3D, 'GeometryInstance3D':GeometryInstance3D, 'VisualInstance3D':VisualInstance3D, 'ImporterMeshInstance3D':ImporterMeshInstance3D, 'Skin':Skin, 
	'ShaderGlobalsOverride':ShaderGlobalsOverride, 'GLTFObjectModelProperty':GLTFObjectModelProperty, 'OggPacketSequence':OggPacketSequence, 'CSGTorus3D':CSGTorus3D, 'CSGSphere3D':CSGSphere3D, 
	'CSGPolygon3D':CSGPolygon3D, 'CSGMesh3D':CSGMesh3D, 'CSGCylinder3D':CSGCylinder3D, 'CSGCombiner3D':CSGCombiner3D, 'CSGBox3D':CSGBox3D, 
	'FastNoiseLite':FastNoiseLite, 'PackedScene':PackedScene, 'PolygonPathFinder':PolygonPathFinder, 'NavigationLink2D':NavigationLink2D, 'NavigationObstacle2D':NavigationObstacle2D, 
	'NavigationAgent2D':NavigationAgent2D, 'NavigationRegion2D':NavigationRegion2D, 'NavigationPolygon':NavigationPolygon, 'NavigationMeshSourceGeometryData2D':NavigationMeshSourceGeometryData2D, 'ConcavePolygonShape2D':ConcavePolygonShape2D, 
	'ConvexPolygonShape2D':ConvexPolygonShape2D, 'CapsuleShape2D':CapsuleShape2D, 'RectangleShape2D':RectangleShape2D, 'CircleShape2D':CircleShape2D, 'SeparationRayShape2D':SeparationRayShape2D, 
	'SegmentShape2D':SegmentShape2D, 'WorldBoundaryShape2D':WorldBoundaryShape2D, 'PathFollow2D':PathFollow2D, 'Path2D':Path2D, 'BoneMap':BoneMap, 
	'SkeletonProfileHumanoid':SkeletonProfileHumanoid, 'StyleBoxLine':StyleBoxLine, 'StyleBoxFlat':StyleBoxFlat, 'StyleBoxTexture':StyleBoxTexture, 'StyleBoxEmpty':StyleBoxEmpty, 
	'ColorPalette':ColorPalette, 'SystemFont':SystemFont, 'FontVariation':FontVariation, 'FontFile':FontFile, 'AnimationLibrary':AnimationLibrary, 
	'Texture3DRD':Texture3DRD, 'TextureCubemapArrayRD':TextureCubemapArrayRD, 'TextureCubemapRD':TextureCubemapRD, 'Texture2DArrayRD':Texture2DArrayRD, 'Texture2DRD':Texture2DRD, 
	'AnimatedTexture':AnimatedTexture, 'DPITexture':DPITexture, 'PlaceholderCubemapArray':PlaceholderCubemapArray, 'PlaceholderCubemap':PlaceholderCubemap, 'PlaceholderTexture2DArray':PlaceholderTexture2DArray, 
	'PlaceholderTexture3D':PlaceholderTexture3D, 'PlaceholderTexture2D':PlaceholderTexture2D, 'CompressedTexture2DArray':CompressedTexture2DArray, 'CompressedCubemapArray':CompressedCubemapArray, 'CompressedCubemap':CompressedCubemap, 
	'Texture2DArray':Texture2DArray, 'CubemapArray':CubemapArray, 'Cubemap':Cubemap, 'CompressedTexture3D':CompressedTexture3D, 'ImageTexture3D':ImageTexture3D, 
	'ExternalTexture':ExternalTexture, 'CameraTexture':CameraTexture, 'GradientTexture2D':GradientTexture2D, 'MeshTexture':MeshTexture, 'AtlasTexture':AtlasTexture, 
	'ImageTexture':ImageTexture, 'CompressedTexture2D':CompressedTexture2D, 'CameraAttributesPractical':CameraAttributesPractical, 'CameraAttributesPhysical':CameraAttributesPhysical, 'CameraAttributes':CameraAttributes, 
	'ConcavePolygonShape3D':ConcavePolygonShape3D, 'ConvexPolygonShape3D':ConvexPolygonShape3D, 'WorldBoundaryShape3D':WorldBoundaryShape3D, 'HeightMapShape3D':HeightMapShape3D, 'CylinderShape3D':CylinderShape3D, 
	'CapsuleShape3D':CapsuleShape3D, 'BoxShape3D':BoxShape3D, 'SphereShape3D':SphereShape3D, 'SeparationRayShape3D':SeparationRayShape3D, 'MeshLibrary':MeshLibrary, 
	'PhysicalSkyMaterial':PhysicalSkyMaterial, 'PanoramaSkyMaterial':PanoramaSkyMaterial, 'ProceduralSkyMaterial':ProceduralSkyMaterial, 'ORMMaterial3D':ORMMaterial3D, 'StandardMaterial3D':StandardMaterial3D, 
	'PointMesh':PointMesh, 'RibbonTrailMesh':RibbonTrailMesh, 'TubeTrailMesh':TubeTrailMesh, 'TorusMesh':TorusMesh, 'TextMesh':TextMesh, 
	'SphereMesh':SphereMesh, 'QuadMesh':QuadMesh, 'PrismMesh':PrismMesh, 'PlaneMesh':PlaneMesh, 'CylinderMesh':CylinderMesh, 
	'CapsuleMesh':CapsuleMesh, 'BoxMesh':BoxMesh, 'PrimitiveMesh':PrimitiveMesh, 'MeshDataTool':MeshDataTool, 'PlaceholderMesh':PlaceholderMesh, 
	'MeshConvexDecompositionSettings':MeshConvexDecompositionSettings, 'GradientTexture1D':GradientTexture1D, 'ParticleProcessMaterial':ParticleProcessMaterial, 'SkeletonModification2DPhysicalBones':SkeletonModification2DPhysicalBones, 'SkeletonModification2DJiggle':SkeletonModification2DJiggle, 
	'PhysicalBone2D':PhysicalBone2D, 'SkeletonModification2DStackHolder':SkeletonModification2DStackHolder, 'JavaObject':JavaObject, 'JavaClass':JavaClass, 'JavaClassWrapper':JavaClassWrapper, 
	'GDScriptSyntaxHighlighter':GDScriptSyntaxHighlighter, 'WebRTCDataChannelExtension':WebRTCDataChannelExtension, 'WebRTCPeerConnectionExtension':WebRTCPeerConnectionExtension, 'RegExMatch':RegExMatch, 'OggPacketSequencePlayback':OggPacketSequencePlayback, 
	'NoiseTexture2D':NoiseTexture2D, 'NoiseTexture3D':NoiseTexture3D, 'OfflineMultiplayerPeer':OfflineMultiplayerPeer, 'MultiplayerSynchronizer':MultiplayerSynchronizer, 'MultiplayerSpawner':MultiplayerSpawner, 
	'LightmapperRD':LightmapperRD, 'JSONRPC':JSONRPC, 
}


## Listens for errors.
static var error_server := A2JErrorServer.new()
## Current state of A2J.
static var current_state:State = State.IDLE
## The time in milliseconds spent during the last [code]to_json[/code] or [code]from_json[/code] call.
static var time_to_finish:float = 0

## Data that [A2JTypeHandler] objects can share & use during serialization.
## Cleared before & after [code]to_json[/code] or [code]from_json[/code] is called.
static var _process_data: Dictionary

## The raw ruleset currently being used in serialization. Gets reset to the default ruleset after serialization.
static var _current_ruleset := default_ruleset

## Array of functions for [A2JTypeHandler] objects to add to. Will be called in order after the main serialization has completed.
static var _process_next_pass_functions:Array[Callable] = []

## Array of property names, pointing to where the data structure being serialized is currently at.
## Used to find exactly where in the data structure an error was found.
static var _tree_position: Array[String]
const _default_tree_position:Array[String] = ['ROOT']


## Do not instantiate this class. All functions & variables are static.
func _init() -> void:
	assert(false, 'A2J class should not be instantiated.')


## Returns the version of the plugin. If version could not be found, returns an empty string.
static func get_version() -> String:
	var config_file := ConfigFile.new()
	config_file.load('res://addons/A2J/plugin.cfg')
	return config_file.get_value('plugin', 'version', '')


## Report an error to Any-JSON.
## [param translations] should be strings.
static func report_error(error:int, ...translations) -> void:
	var a2jError_ = A2JTypeHandler.a2jError % ['A2J', ' > '.join(A2J._tree_position)]
	var message = error_strings.get(error)
	if message is not String: printerr(a2jError_+str(error))
	else:
		for tr in translations:
			if tr is not String && tr is not StringName: continue
			message = message.replace('~~', tr)
		printerr(a2jError_+message)

	# Emit error.
	error_server.core_error.emit(error, message)


## Convert [param value] to an AJSON object or a JSON friendly value.
## If [param value] is an [Object], only objects in the [code]object_registry[/code] can be converted.
## [br][br]
## Returns [code]null[/code] if failed.
static func to_json(value:Variant, ruleset:Dictionary[String,Dictionary]=_current_ruleset) -> Variant:
	var start_tick := Time.get_ticks_usec()
	current_state = State.SERIALIZING
	_current_ruleset = ruleset
	_tree_position = _default_tree_position.duplicate()
	_process_next_pass_functions.clear()
	_process_data.clear()
	_init_handler_data()
	var result = _to_json(value, ruleset)
	result = _call_next_pass_functions(value, result, ruleset)
	_process_data.clear()
	_current_ruleset = default_ruleset
	current_state = State.IDLE
	time_to_finish = (Time.get_ticks_usec()-start_tick)/1000.0
	return result


static func _to_json(value:Variant, raw_ruleset:Dictionary[String,Dictionary]=_current_ruleset) -> Variant:
	var ruleset := _get_runtime_ruleset(value, raw_ruleset)

	# Get type of value.
	var type := type_string(typeof(value))
	var object_class: String
	if type == 'Object': object_class = A2JUtil.get_class_name(value)

	# If type excluded, return null.
	if _type_excluded(type, ruleset): return null
	# If class excluded, return null.
	elif object_class && _class_excluded(object_class, ruleset): return null
	# If type is primitive, return value unchanged (except when rules apply).
	if typeof(value) in primitive_types:
		return value

	# Get type handler.
	var handler = type_handlers.get(type, null)
	if handler == null:
		report_error(0, type)
		return null
	handler = handler as A2JTypeHandler

	# Call midpoint function.
	var midpoint = ruleset.get('midpoint')
	if midpoint is Callable:
		# If returns true, discard conversion.
		if midpoint.call(value, ruleset) == true: return null

	# Return converted value.
	return handler.to_json(value, ruleset)


## Convert [param value] to it's original value. Returns [code]null[/code] if failed.
static func from_json(value, ruleset:Dictionary[String,Dictionary]=_current_ruleset) -> Variant:
	var start_tick := Time.get_ticks_usec()
	current_state = State.DESERIALIZING
	_current_ruleset = ruleset
	_tree_position = _default_tree_position.duplicate()
	_process_next_pass_functions.clear()
	_process_data.clear()
	_init_handler_data()
	var result = _from_json(value, ruleset)
	result = _call_next_pass_functions(value, result, ruleset)
	_process_data.clear()
	_current_ruleset = default_ruleset
	current_state = State.IDLE
	time_to_finish = (Time.get_ticks_usec()-start_tick)/1000.0
	return result


## [param type_details] tells the function how to type the result.
static func _from_json(value, type_details:Dictionary={}, raw_ruleset:Dictionary[String,Dictionary]=_current_ruleset) -> Variant:
	var ruleset = _get_runtime_ruleset(value, raw_ruleset)

	# Get type of value.
	var type: String
	var object_class: String
	if value is Dictionary:
		var split_type:Array = value.get('.t', '').split(':')
		type = split_type[0]
		if split_type.size() == 2: object_class = split_type[1]
		if type == '': type = 'Dictionary'
	elif value is Array: type = 'Array'
	else: type = type_string(typeof(value))

	# If type excluded, return null.
	if _type_excluded(type, ruleset): return null
	# If class excluded, return null.
	elif object_class && _class_excluded(object_class, ruleset): return null
	# If type is primitive.
	elif typeof(value) in primitive_types:
		# If float is a whole number, convert to an int (JSON in Godot converts ints to floats, we need to convert them back).
		if value is float && fmod(value, 1) == 0: return int(value)
		return value

	# Get type handler.
	var handler = type_handlers.get(type, null)
	if handler == null:
		report_error(0, type)
		return null
	handler = handler as A2JTypeHandler

	# Call midpoint function.
	var midpoint = ruleset.get('midpoint')
	if midpoint is Callable:
		# If returns true, discard conversion.
		if midpoint.call(value, ruleset) == true: return null

	# Convert value.
	var result = handler.from_json(value, ruleset)
	# Type dictionary.
	if result is Dictionary:
		result = A2JUtil.type_dictionary(result, type_details)
	# Type array.
	elif result is Array:
		result = A2JUtil.type_array(result, type_details)
	# Type other.
	elif type_details.get('type') is int:
		result = type_convert(result, type_details.get('type'))
	# Return result.
	return result


## Get the runtime ruleset.
static func _get_runtime_ruleset(variant:Variant, ruleset:Dictionary[String,Dictionary]) -> Dictionary:
	var result:Dictionary = {}
	for key:String in ruleset:
		var rule_group:Dictionary = ruleset[key]

		# Determine if the group is valid in this instance.
		var valid:bool = false
		if key == '@global': valid = true
		elif key.begins_with('@depth'):
			var expression:String = key.split(':')[-1]
			var expected_depth:int = expression.to_int()
			var current_depth:int = _tree_position.size()-1
			if expression.ends_with('+'):
				if current_depth >= expected_depth: valid = true
			elif expression.ends_with('-'):
				if current_depth <= expected_depth: valid = true
			else:
				if current_depth == expected_depth: valid = true
		elif variant is RefCounted:
			if variant.is_class(key): valid = true
		# Skip group if invalid.
		if not valid: continue

		# Merge rule group with result.
		for key_2:String in rule_group:
			var valid_2:bool = true
			var split_key := key_2.split('@')
			if split_key[-1] == 'ser' && current_state != State.SERIALIZING: valid_2 = false
			elif split_key[-1] == 'des' && current_state != State.DESERIALIZING: valid_2 = false
			if not valid_2: continue
			var new_key:String = split_key[0]
			var value = rule_group[new_key]
			if not result.has(new_key):
				result.set(new_key, value)
				continue
			elif value is Array:
				result[new_key].append_array(value)
			elif value is Dictionary:
				result[new_key].merge(value, true)

	return result


## Returns whether or not the [param type] is excluded in the [param ruleset].
static func _type_excluded(type:String, ruleset:Dictionary) -> bool:
	# Get type exclusions & inclusions.
	var type_exclusions = ruleset.get('type_exclusions', [])
	var type_inclusions = ruleset.get('type_inclusions', [])
	# Return whether or not the type is excluded.
	if type_exclusions is Array && type_inclusions is Array:
		return type in type_exclusions or (type_inclusions.size() > 0 && type not in type_inclusions)

	# Throw error if is not an array.
	report_error(1)
	return true


## Returns whether or not the [param object_class] is excluded in the [param ruleset].
static func _class_excluded(object_class:String, ruleset:Dictionary) -> bool:
	# Get class exclusions & inclusions.
	var class_exclusions = ruleset.get('class_exclusions', [])
	var class_inclusions = ruleset.get('class_inclusions', [])
	# Return whether or not class is excluded.
	if class_exclusions is Array && class_inclusions is Array:
		return object_class in class_exclusions or (class_inclusions.size() > 0 && object_class not in class_inclusions)

	# Throw error if is not an array.
	report_error(2)
	return true


## Initialize data for all registered [code]type_handlers[/code], into the [code]_process_data[/code] variable.
static func _init_handler_data() -> void:
	for key:String in type_handlers:
		var handler:A2JTypeHandler = type_handlers[key]
		_process_data.merge(handler.init_data.duplicate(true), true)


## Calls all functions in [code]_process_next_pass_functions[/code] with the given [param value], [param result], & [param ruleset] (in that order).
## [param result] is changed to the return value of the last next pass function & [param result] is returned after all functions have been called.
static func _call_next_pass_functions(value, result, ruleset:Dictionary) -> Variant:
	for callable:Callable in _process_next_pass_functions:
		result = callable.call(value, result, ruleset)
	return result
