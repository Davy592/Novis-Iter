extends Quest

class_name ItemQuest

var item_to_collect: Item:
	set(new_item): item_to_collect = new_item
	get: return item_to_collect
var collected_items: int:
	set(new_collected_items): collected_items = new_collected_items
	get: return collected_items

## Inizializza la quest (con super()) e 
func _init(data):
	super(data)
	
	# Aggiungi dati aggiuntivi per l'item da collezionare
	item_to_collect = init_item(data['collect_item_file'], data['collect_item_quantity'])
	init_collected_items() # Controlla che non esista giá l'oggetto nell'inventario

func init_collected_items():
	var search_item = Global.inventory.get_item_from_name(item_to_collect.name)
	
	if search_item != null:
		collected_items = search_item.quantity
		check_quantity_reached()
	else:
		collected_items = 0

func update(item_name: String):
	if item_to_collect.name == item_name:
		collected_items += 1
	
	check_quantity_reached()

func check_quantity_reached():
	if collected_items == item_to_collect.get_quantity() or stage + 10 > 90:
		Global.quest_handler.set_current_stage(id, 90)
	else:
		Global.quest_handler.set_current_stage(id, stage + 10)
