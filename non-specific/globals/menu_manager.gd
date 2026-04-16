extends Node

@onready var player: Player = get_tree().get_first_node_in_group("player")
@export var game_ui: GameUI
@export var tab_order: Array[String]
@export var menu_tabs: Dictionary[String, CanvasLayer]
var current_tab: CanvasLayer
var current_tab_index: int
var is_open: bool = false


# Function Information
# Use - Menu Navigation
# Does - Set initial tab variables
func _ready() -> void:
	current_tab = GetTabOfIndex(current_tab_index)
	current_tab_index = 0


# Function Information
# Use - Menu Navigation
# Does - Gets the tab connected with the given index if present. If index out of range, print 
#		error and return null.
# Debug - Error statement
#		Index out of range
func GetTabOfIndex(index: int) -> CanvasLayer:
	if index < 0 or index >= len(tab_order):
		print("Error getting tab of index " + str(index) + ", it is out of range of the tab order array.")
		return
	return GetTabOfName(tab_order[index])


# Function Information
# Use - Menu Navigation
# Does - Gets the tab connected with the given name if present. If not, appropiate error printed and 
#		null returned.
# Debug - Error statement
#		Tab name not present in menu tabs or tab order
func GetTabOfName(tab_name: String) -> CanvasLayer:
	if tab_name not in tab_order: 
		print("Error accessing tab " + tab_name + ", it is not in tab order.")
		return
	if tab_name not in menu_tabs:
		print("Error accessing tab " + tab_name + ", it is not in menu tabs dict.")
		return
	return menu_tabs[tab_name]


# Function Information
# Use - Menu Navigation
# Does - Gets the index of the given tab's name in tab order if present. If not, appropiate error 
#		printed and -1 returned
# Debug - Error statement
#		Tab name not present in menu tabs or tab order
func GetOrderIndexOfName(tab_name: String) -> int:
	if tab_name not in tab_order:
		print("Error accessing tab index of tab " + tab_name + ", it is not in tab order.")
	if tab_name not in menu_tabs:
		print("Error accessing tab index of tab " + tab_name + ", it is not in menu tabs dict.")
	return tab_order.find(tab_name)


# Function Information
# Use - Menu Navigation
# Does - Opens or closes the menu, or switches between menus tabs if open
func _unhandled_input(event: InputEvent) -> void:
	# Switch between menu states of opened and closed
	if event.is_action_pressed("menu") and !is_open:
		OpenMenu()
	elif event.is_action_pressed("menu") and is_open:
		CloseMenu()
	
	# Only move between tabs if menu is opened
	if !is_open:
		return
	
	# Move between tabs depending on inputted direction
	if event.is_action_pressed("next_menu_tab"):
		MoveToNextTab()
	elif event.is_action_pressed("previous_menu_tab"):
		MoveToPreviousTab()


# Function Information
# Use - Menu Navigation
# Does - Move to the next tab in the tab order array
func MoveToNextTab() -> void:
	# Next tab in order
	if current_tab_index < len(tab_order) - 1:
		current_tab_index += 1
		current_tab = GetTabOfIndex(current_tab_index)
	# Loop back to first tab
	else:
		current_tab_index = 0
		current_tab = GetTabOfIndex(current_tab_index)
	# Showcase new tab, hide previous tab
	UpdateTabVisibility()


# Function Information
# Use - Menu Navigation
# Does - Move to the previous tab in the tab order array
func MoveToPreviousTab() -> void:
	# Previous tab in order
	if current_tab_index > 0:
		current_tab_index -= 1
		current_tab = GetTabOfIndex(current_tab_index)
	# Loop back to final tab
	else:
		current_tab_index = len(tab_order) - 1
		current_tab = GetTabOfIndex(current_tab_index)
	# Showcase new tab, hide previous tab
	UpdateTabVisibility()


# Function Information
# Use - Menu Navigation
# Does - Sets current tab values to tab connected to given name
func MoveToTabOfName(tab_name: String) -> void:
	current_tab = GetTabOfName(tab_name)
	current_tab_index = GetOrderIndexOfName(tab_name)
	UpdateTabVisibility()


# Function Information
# Use - Menu Navigation
# Does - Hides all but the current tab, makes current tab visible
func UpdateTabVisibility() -> void:
	for tab in menu_tabs.values():
		if tab != current_tab:
			tab = tab as CanvasLayer
			tab.visible = false
		elif tab == current_tab:
			tab = tab as CanvasLayer
			tab.visible = true


# Function Information
# Use - Menu Navigation
# Does - Opens menu, either to specified tab or tab it was last closed on
func OpenMenu(new_tab_name: String = "") -> void:
	is_open = true
	player.RemoveControl()
	game_ui.hide()
	
	if new_tab_name != "":
		MoveToTabOfName(new_tab_name)
	else:
		UpdateTabVisibility()


# Function Information
# Use - Menu Navigation
# Does - Closes the menu by hiding it
func CloseMenu() -> void:
	is_open = false
	player.ReturnControl()
	current_tab.visible = false
	game_ui.show()
