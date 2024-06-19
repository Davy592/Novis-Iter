class_name Quest

#region: Variables
var id : int:
	set(new_id): id = new_id
	get: return id
var title : String:
	set(new_title): title = new_title
	get: return title
var description : String:
	set(new_description): description = new_description
	get: return description
var stage : int: 
	set(new_stage): stage = new_stage
	get: return stage
var is_completed : bool:
	set(new_completed): is_completed = new_completed
	get: return is_completed
var reward_item : Item:	
	set(new_reward): reward_item = new_reward
	get: return reward_item
#endregion

# Called when the node enters the scene tree for the first time.
func _init(data):
	id = data['id']
	title = data['title']
	description = data['description']
	stage = 0
	is_completed = false
	
	init_item(data['reward_item_file'], data['reward_item_quantity'])
	
func init_item(json_item_file: String, quantity: int):
	var json_as_text = FileAccess.get_file_as_string(json_item_file)
	var item_data = JSON.parse_string(json_as_text)
	
	item_data['quantity'] = quantity
	item_data['texture'] = load(item_data['texture'])
	reward_item = Item.new(item_data)

func check_completed() -> bool:
	return false
