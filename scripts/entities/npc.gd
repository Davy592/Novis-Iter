extends CharacterBody2D

#region: Variables
@export var speed: int = 100
@export var corsa=false
var current_state = IDLE * int(!corsa) + NEW_DIR * int(corsa)

var state: String = "idle"
var direction: String = "front"
var dir: Vector2 = Vector2.RIGHT
var start_pos: Vector2

# Stati di movimento
@export var walk_radius: int = 200 
var is_chatting: bool = false

# Dialogo
@export var dialogue_limit: int
var dialogue_id: int = 0

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
		if not corsa:
			current_state = IDLE
		else:
			current_state = NEW_DIR
	else:
		#position += dir * speed * delta
		#velocity = dir * speed
		#move_and_slide()
		var collision = move_and_collide(dir * speed * delta)
		if collision != null:
			dir = choose([
				Vector2.RIGHT, 
				Vector2.UP, 
				Vector2.LEFT, 
				Vector2.DOWN
			])

#endregion

## Consente la selezione casuale in un array di valori
func choose(array):
	array.shuffle()
	return array.front()

#region: Signals
func _on_timer_timeout():
	if not corsa:
		$Timer.wait_time = choose([0.5, 1, 1.5])
		current_state = choose([IDLE, NEW_DIR, MOVE])
	else:
		if current_state == NEW_DIR:
			$Timer.wait_time = choose([0.01])
			current_state = MOVE
		else:
			$Timer.wait_time = choose([1, 2, 3])
			current_state = NEW_DIR


func _on_dialogic_signal(argument: Dictionary):
	var key = get_key_from_argument(argument)
	if key == "":
		return
	
	match key:
		"accepted":
			handle_accepted(argument[key])
		"start":
			handle_start(argument[key])
		"end":
			handle_end(argument[key])

func get_key_from_argument(argument: Dictionary) -> String:
	for k in ["start", "accepted", "end"]:
		if argument.has(k):
			return k
	return ""

func handle_accepted(quest_id: String):
	if quest == null:
		return
	
	var id = int(quest_id)
	if quest.id == id:
		Global.quest_handler.add(quest)
		
		if quest is ItemQuest:
			quest.init_collected_items()

func handle_start(npc_name: String):
	if name != npc_name:
		return
	
	is_chatting = true
	if corsa:
		speed = 0
		current_state = IDLE
		dir = Vector2.DOWN
		state = "idle"
		direction = "front"
	Dialogic.VAR.dialogue.dialogue_id = dialogue_id

func handle_end(npc_name: String):
	if name != npc_name:
		return

	is_chatting = false
	
	if quest != null:
		check_current_stage()
	else:
		update_dialogue_id()
#endregion

## Metodo di cui fare override nelle classi piú specifiche
## per modificare il comportamento dell'NPC al cambiare dello stage
func check_current_stage():
	pass

func update_dialogue_id():
	if dialogue_id + 1 <= dialogue_limit:
		dialogue_id += 1
		Dialogic.VAR.dialogue.dialogue_id += 1
