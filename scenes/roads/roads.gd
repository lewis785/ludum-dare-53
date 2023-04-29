extends Node2D

const Structure = preload("res://scenes/structure/structure.gd")


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
	# Set the points property to draw a line from (0, 0) to (100, 100)
	line.points = [start.position, end.position]
	line.width = 2
	line.default_color = Color(0.43921, 0.3647, 0.3372, 0.8)
	# Add the Line2D node as a child of the scene
	add_child(line)
	
func update_roads():
	print("Updating roads")
	var root = self.get_tree().current_scene
	var depot = root.find_child('supply_depot')
	var structs = structures(root.find_children('*structure*'))
	
	for struct in structs:
		if (struct.owned):
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
