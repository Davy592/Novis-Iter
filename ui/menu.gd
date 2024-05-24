extends Control

# Variable to keep track of the current selected button index
var current_index = 0
@onready var MenuEntries = $MarginContainer/VBoxContainer/MenuEntries
@onready var child_count = MenuEntries.get_child_count()

func _ready():
	select_button(0)

func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		move_selection(1)
	elif Input.is_action_just_pressed("ui_up"):
		move_selection(-1)
	
# Function to select a button by index
func select_button(index):
	# Ensure index is within bounds
	if index >= 0 and index < child_count:
		# Select the button at the given index
		var button_to_select = MenuEntries.get_child(index)
		if button_to_select is Button:
			button_to_select.focus_mode = Control.FOCUS_ALL
			button_to_select.grab_focus()
			current_index = index

# Function to move selection up or down
func move_selection(direction):
	var new_index = current_index + direction
	new_index += int(new_index < 0) * child_count
	new_index %= child_count
	select_button(new_index)
