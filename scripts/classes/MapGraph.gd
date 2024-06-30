class_name Graph

class MapNodeData:
	
	signal map_node_data_updated
	
	var tile_info: TileInfo
	var x: int
	var y: int
	
	func _init(tile_info: TileInfo, x: int, y: int):
		self.tile_info = tile_info
		self.x = x
		self.y = y
	
	func get_x():
		return self.x

	func get_y():
		return self.y
	
	func set_tile_info(tile_info):
		self.tile_info = tile_info
		map_node_data_updated.emit()
	
	func get_tile_info() -> TileInfo:
		return tile_info

class BFSIterator:
	
	var graph: Graph
	var to_elaborate
	var elaborated
	var current_node_id: int
	
	func _init(graph: Graph, nodes_count: int, current_node_id: int):
		self.current_node_id = current_node_id
		self.graph = graph
		to_elaborate = [current_node_id]
		elaborated = Array([], TYPE_BOOL, &"", null) # Array[bool]
		elaborated.resize(nodes_count)
		#print(elaborated)
	
	func has_next() -> bool:
		return not to_elaborate.is_empty()
	
	func next() -> int:
		current_node_id = to_elaborate.pop_back()
		var map_node = graph.nodes[current_node_id]
		var neighbor_id = map_node.sides[MapNode.LINK_SIDE.TOP]
		if neighbor_id != -1 and not elaborated[neighbor_id]:
			to_elaborate.append(neighbor_id)
		neighbor_id = map_node.sides[MapNode.LINK_SIDE.RIGHT]
		if neighbor_id != -1 and not elaborated[neighbor_id]:
			to_elaborate.append(neighbor_id)
		neighbor_id = map_node.sides[MapNode.LINK_SIDE.BOTTOM]
		if neighbor_id != -1 and not elaborated[neighbor_id]:
			to_elaborate.append(neighbor_id)
		neighbor_id = map_node.sides[MapNode.LINK_SIDE.LEFT]
		if neighbor_id != -1 and not elaborated[neighbor_id]:
			to_elaborate.append(neighbor_id)
		elaborated[current_node_id] = true
		#print(to_elaborate)
		return current_node_id

class MapNode:
	
	enum LINK_SIDE {
		TOP,
		RIGHT,
		BOTTOM,
		LEFT
	}
	
	var data
	var sides
	
	func _init(data):
		self.data = data
		self.sides = [-1, -1, -1, -1]

# gli id dei nodi corrispondono all'indice della cella dell'array in cui si trovano
var nodes
var unused_ids

func _init():
	self.nodes = []
	self.unused_ids = []

func substitute_char_at_index(s: String, index: int, new_char: String) -> String:
	return s.substr(0, index) + new_char + s.substr(index + 1, s.length() - index - 1)

func exists(id: int) -> bool:
	if id < 0 or id > nodes.size():
		return false
	return nodes[id] != null

func add_node(data) -> int:
	var id
	if not unused_ids.is_empty():
		id = unused_ids.pop_front()
		nodes[id] = MapNode.new(data)
	else:
		id = nodes.size()
		nodes.push_back(MapNode.new(data))
	#print(nodes)
	return id

func link_exists(target_id: int, side: MapNode.LINK_SIDE) -> bool:
	return nodes[target_id].sides[side] != -1

func remove_link(target_id: int, side: MapNode.LINK_SIDE) -> void:
	assert(link_exists(target_id, side), "Graph: link doesn't exist.")
	assert(exists(target_id), "Graph: node with target_id " + str(target_id) + " doesn't exist.")
	nodes[target_id].sides[side] = -1

func add_link(id1: int, id2: int, side: MapNode.LINK_SIDE) -> void:
	assert(not link_exists(id1, side), "Graph: link already exists.")
	assert(exists(id1), "Graph: node with target_id " + str(id1) + " doesn't exist.")
	assert(exists(id2), "Graph: node with value_id " + str(id2) + " doesn't exist.")
	nodes[id1].sides[side] = id2
	match side:
		MapNode.LINK_SIDE.TOP:
			nodes[id2].sides[MapNode.LINK_SIDE.BOTTOM] = id1
		MapNode.LINK_SIDE.RIGHT:
			nodes[id2].sides[MapNode.LINK_SIDE.LEFT] = id1
		MapNode.LINK_SIDE.BOTTOM:
			nodes[id2].sides[MapNode.LINK_SIDE.TOP] = id1
		MapNode.LINK_SIDE.LEFT:
			nodes[id2].sides[MapNode.LINK_SIDE.RIGHT] = id1

func get_neighbor(id: int, side: MapNode.LINK_SIDE) -> int:
	assert(exists(id), "Graph: node with id = " + str(id) + " doesn't exist.")
	return nodes[id].sides[side]

func remove_node(id: int) -> void:
	assert(exists(id), "Graph: node with id = " + str(id) + " doesn't exist.")
	var top_id = nodes[id].sides[MapNode.LINK_SIDE.TOP]
	var right_id = nodes[id].sides[MapNode.LINK_SIDE.RIGHT]
	var bottom_id = nodes[id].sides[MapNode.LINK_SIDE.BOTTOM]
	var left_id = nodes[id].sides[MapNode.LINK_SIDE.LEFT]
	if top_id != -1:
		nodes[top_id].sides[MapNode.LINK_SIDE.BOTTOM] = -1
	if right_id != -1:
		nodes[right_id].sides[MapNode.LINK_SIDE.LEFT] = -1
	if bottom_id != -1:
		nodes[bottom_id].sides[MapNode.LINK_SIDE.TOP] = -1
	if left_id != -1:
		nodes[left_id].sides[MapNode.LINK_SIDE.RIGHT] = -1
	nodes[id] = null
	#print(nodes)
	unused_ids.push_back(id)

func get_node_data(id:int) -> Variant:
	assert(exists(id), "Graph: node with id = " + str(id) + " doesn't exist.")
	return nodes[id].data

func get_bfs_iterator(id) -> BFSIterator:
	assert(exists(id), "Graph: node with id = " + str(id) + " doesn't exist.")
	return BFSIterator.new(self, nodes.size(), id)

func is_node_a_bridge(id: int) -> bool:
	assert(exists(id), "Graph: node with id = " + str(id) + " doesn't exist.")
	var visited = Array([], TYPE_INT, &"", null)
	var map_node: MapNode = nodes[id]
	var current_map_node: MapNode
	var to_visit = []
	var current_id = 0
	
	# remove node from its neighbors
	var top_id = nodes[id].sides[MapNode.LINK_SIDE.TOP]
	var right_id = nodes[id].sides[MapNode.LINK_SIDE.RIGHT]
	var bottom_id = nodes[id].sides[MapNode.LINK_SIDE.BOTTOM]
	var left_id = nodes[id].sides[MapNode.LINK_SIDE.LEFT]
	if top_id != -1:
		nodes[top_id].sides[MapNode.LINK_SIDE.BOTTOM] = -1
	if right_id != -1:
		nodes[right_id].sides[MapNode.LINK_SIDE.LEFT] = -1
	if bottom_id != -1:
		nodes[bottom_id].sides[MapNode.LINK_SIDE.TOP] = -1
	if left_id != -1:
		nodes[left_id].sides[MapNode.LINK_SIDE.RIGHT] = -1
	
	visited.resize(nodes.size())
	for i in range(nodes.size()):
		if nodes[i] == null:
			visited[i] = -1
		elif nodes[i].data.tile_info == null:
			visited[i] = 1
		else:
			visited[i] = 0
	
	while current_id == id or nodes[current_id] == null:
		current_id += 1
	
	to_visit.push_back(current_id)
	
	#if nodes[neighbor_id].data.tile_info != null:
		#to_visit.append(neighbor_id)
	#else:
		#visited[neighbor_id] = 1
	
	# bfs visit
	while not to_visit.is_empty():
		current_id = to_visit.pop_back()
		current_map_node = nodes[current_id]
		var neighbor_id = current_map_node.sides[MapNode.LINK_SIDE.TOP]
		if neighbor_id != -1 and not visited[neighbor_id]:
			to_visit.append(neighbor_id)
		neighbor_id = current_map_node.sides[MapNode.LINK_SIDE.RIGHT]
		if neighbor_id != -1 and not visited[neighbor_id]:
			to_visit.append(neighbor_id)
		neighbor_id = current_map_node.sides[MapNode.LINK_SIDE.BOTTOM]
		if neighbor_id != -1 and not visited[neighbor_id]:
			to_visit.append(neighbor_id)
		neighbor_id = current_map_node.sides[MapNode.LINK_SIDE.LEFT]
		if neighbor_id != -1 and not visited[neighbor_id]:
			to_visit.append(neighbor_id)
		visited[current_id] = 1
	
	# controlla se hai visto tutti i nodi
	var i = 0
	while (i < visited.size() and visited[i] != 0) or i == id:
		i += 1
	
	# restore node from its neighbors
	top_id = nodes[id].sides[MapNode.LINK_SIDE.TOP]
	right_id = nodes[id].sides[MapNode.LINK_SIDE.RIGHT]
	bottom_id = nodes[id].sides[MapNode.LINK_SIDE.BOTTOM]
	left_id = nodes[id].sides[MapNode.LINK_SIDE.LEFT]
	if top_id != -1:
		nodes[top_id].sides[MapNode.LINK_SIDE.BOTTOM] = id
	if right_id != -1:
		nodes[right_id].sides[MapNode.LINK_SIDE.LEFT] = id
	if bottom_id != -1:
		nodes[bottom_id].sides[MapNode.LINK_SIDE.TOP] = id
	if left_id != -1:
		nodes[left_id].sides[MapNode.LINK_SIDE.RIGHT] = id
	
	if i == visited.size():
		return false
	else:
		return true
