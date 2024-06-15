extends CharacterBody2D

#region: Variables
const speed : int = 100
var current_state = IDLE

var state : String = "idle"
var direction : String = "front"
var dir : Vector2 = Vector2.RIGHT
var start_pos : Vector2

# Stati di movimento
@export var walk_radius : int = 200 

var is_chatting : bool = false

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
	Dialogic.signal_event.connect(_on_dialogic_signal)

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

func _on_dialogic_signal(argument: String):
	if argument == "chat_started":
		is_chatting = true
	if argument == "chat_ended":
		is_chatting = false
#endregion
