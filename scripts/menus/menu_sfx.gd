extends Node

@export var hover_sound: AudioStreamPlayer
@export var click_sound: AudioStreamPlayer

func _ready():
	var tree = get_tree()
	
	# Connect to node_added so we catch everything new
	tree.node_added.connect(_on_node_added)

	# Also process existing nodes
	_connect_buttons(tree.root)

func _on_node_added(node):
	_connect_buttons(node)

func _connect_buttons(node):
	if node is BaseButton:
		# Avoid duplicate connections
		if not node.mouse_entered.is_connected(_on_hover):
			node.mouse_entered.connect(_on_hover)
		if not node.button_down.is_connected(_on_click):
			node.button_down.connect(_on_click)

	# Recurse through children
	for child in node.get_children():
		_connect_buttons(child)


func _on_hover():
	if hover_sound:
		hover_sound.play()


func _on_click():
	if click_sound:
		click_sound.play()
