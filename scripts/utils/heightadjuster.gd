extends Node

var character : CharacterBody2D
var tilemap : TileMap
var layers

@export var ground_layer: int = 1
@export var high_layer: int = 0

func _ready():
	character = $Player
	tilemap = $TileMap 
	layers = tilemap.get_layers_count()

## Eleva il player quando é su un tile 'elevato' e
## lo fa collidere con i ground tile altrimenti
func _physics_process(delta):
	var make_above_ground = check_if_elevated()
	
	# Se il player é su un tile che dovrebbe essere 'elevato', 
	#   imposta il layer/mask da default a high (e.g. ponte)
	# Altrimenti, imposta il ground layer a default
	set_mask_and_collision(ground_layer, !make_above_ground)
	set_mask_and_collision(high_layer, make_above_ground)

func check_if_elevated() -> bool: 
	# Controlla il tile sotto il player
	var tile_under: Vector2i = tilemap.local_to_map(character.position)
	tile_under.x /= tilemap.scale.x
	tile_under.y /= tilemap.scale.y
	
	# Cicla per tutti i layer, e restituisce true quando trova il layer 
	# con i tile aventi proprietá 'elevate' attiva 
	for layer in layers:
		var tile_data = tilemap.get_cell_tile_data(layer, tile_under)
		
		if(tile_data && tile_data.get_custom_data("elevate")):
			return true
	
	return false

func set_mask_and_collision(layer: int, value: bool):
	#if(value):
		#print("Active: " + str(layer))
	#else:
		#print("Unactive: " + str(layer) + "\n")
	
	character.set_collision_layer_value(layer, value)
	character.set_collision_mask_value(layer, value)
