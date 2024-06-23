extends CharacterBody2D

#region: Variables
const speed: int = 100
var current_state = IDLE

var state: String = "idle"
var direction: String = "front"
var dir: Vector2 = Vector2.RIGHT
var start_pos: Vector2

# Stati di movimento
@export var walk_radius: int = 200 
var is_chatting: bool = false

# AnimatedSprite
@export var sprite_frames : SpriteFrames:
	set(new_sprite_frames): 
		if new_sprite_frames != null:
			sprite_frames = new_sprite_frames
			$AnimatedSprite2D.sprite_frames = new_sprite_frames
	get: 
		return $AnimatedSprite2D.sprite_frames

# Quest
@export_file("*.json") var json_quest_file
var quest: Quest = null

# Dialogo (sincronizzato con DialogueActionable)
@export var dialogue_file: DialogicTimeline:
	set(new_dialog):
		if new_dialog != null:
			dialogue_file = new_dialog
			$DialogueActionable.dialogue_resource = new_dialog
	get:
		return $DialogueActionable.dialogue_resource

## Possibili stati dell'NPC
enum {
	IDLE,
	NEW_DIR,
	MOVE
}
#endregion

func _ready():
	randomize()
	start_pos = position
	
	if json_quest_file != null:
		init_quest()
	
	# Connessione ai signal
	Dialogic.signal_event.connect(_on_dialogic_signal)

func init_quest():
	var json_as_text = FileAccess.get_file_as_string(json_quest_file)
	var quest_data = JSON.parse_string(json_as_text)
	
	if quest_data.has('collect_item_file'):
		quest = ItemQuest.new(quest_data)
	else:
		quest = Quest.new(quest_data)

#region: NPC Movement
## Acquisisce il movimento dell'NPC (se consentito) e determina
## la prossima azione da eseguire in base al suo stato  
func _process(delta):	
	if walk_radius == 0:
		return
	
	get_movement()
	play_animation()
		
	if is_chatting:
		return
		
	update_movement_state(delta)
	
## Imposta la direzione e lo stato attuale dell'NPC
## sulla base della sua attuale direzione (identificata da 'dir') 
# Solo quando é in stato MOVE e non sta parlando col Player bisogna 
# eseguire l'animazione 'walk', nel caso in cui é in stato di IDLE 
# o NEW_DIR, l'NPC deve rimanere nella direzione precedente e 
# semplicemente eseguire l'idle animation 
func get_movement():
	if current_state == MOVE and !is_chatting:
		state = "walk"
		if dir.y > 0:
			direction = "front"
		elif dir.y < 0:
			direction = "back"
		elif dir.x > 0:
			direction = "right"
		elif dir.x < 0:
			direction = "left"
	else:
		state = "idle"

## Esegue l'animazione dell'NPC in base a direzione e stato corrente
func play_animation():
	$AnimatedSprite2D.play(direction + "_" + state)
	
## Aggiorna il comportamento dell'NPC sulla base dello stato corrente
func update_movement_state(delta):
	match current_state:
		IDLE:
			pass
		NEW_DIR:
			dir = choose([
				Vector2.RIGHT, 
				Vector2.UP, 
				Vector2.LEFT, 
				Vector2.DOWN
			])
		MOVE:
			move(delta)

## Movimento dell'NPC (con controllo su distanza percorsa)
# Se l'NPC si muove troppo lontano dal suo punto iniziale
# sará costretto a rimanere fermo. L'unica sua possibilitá
# é cambiare direzione, cosí da continuare a camminare
func move(delta):
	var updated_pos = position + dir * speed * delta
	if start_pos.distance_to(updated_pos) >= walk_radius:
		current_state = IDLE
	else:
		position += dir * speed * delta
#endregion

## Consente la selezione casuale in un array di valori
func choose(array):
	array.shuffle()
	return array.front()

#region: Signals
func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])	

func _on_dialogic_signal(argument: Dictionary):
	var key = ""

	if quest != null:
		# Determina quale chiave è presente nel dizionario
		if argument.has("start"):
			key = "start"
		elif argument.has("accepted"):
			key = "accepted"
		elif argument.has("end"):
			key = "end"

		# Se una delle chiavi è stata trovata, 
		# esegui l'azione corrispondente
		if key == "accepted":
			var id = int(argument[key])
			
			if quest.id == id:			
				Global.quest_handler.add(quest)
				
				# Controlla che l'item desiderato sia giá nell'inventario
				if quest is ItemQuest:
					quest.init_collected_items()
		elif key == "start" or key == "end":
			var npc_name = argument[key]
			
			if name == npc_name:
				is_chatting = (key == "start")
				
				if !is_chatting:
					check_current_stage()
#endregion

## Metodo di cui fare override nelle classi piú specifiche
## per modificare il comportamento dell'NPC al cambiare dello stage
func check_current_stage():
	pass
