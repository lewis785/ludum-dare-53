extends Node2D

const Structure = preload("res://scenes/structure/structure.gd")
var roadShader: ShaderMaterial = load("res://shaders/roads.tres")
var goodRoadTexture = load("res://assets/terrain/road_good.png")
var badRoadTexture = load("res://assets/terrain/road_bad.png")


func structures(nodes : Array[Node]) -> Array[Structure]:
	var structures : Array[Structure] = []
	for node in nodes:
		print(node.get_class())
		if node.is_class("Node2D"):
			var marker : Structure = node
			structures.append(marker)
		
	return structures

func draw_road(start, end):

	var line = Line2D.new()
	
	roadShader.set_shader_parameter("texture", badRoadTexture)
	
	line.material = roadShader
	line.points = [start.position, end.position]
	line.width = 1
	# Add the Line2D node as a child of the scene
	add_child(line)
	
func update_roads():
	var root = self.get_tree().current_scene
	var depot = get_tree().get_nodes_in_group('depots')[0]
	var structs = get_tree().get_nodes_in_group('structures')
	
	for struct in structs:
		if struct.owned:
			print(struct.owned)
			draw_road(depot, struct)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var signal_bus = get_node("/root/SignalBus")
	signal_bus.connect('update_ownership', update_roads)
	update_roads()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
