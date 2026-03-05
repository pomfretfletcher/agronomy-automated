class_name Slot
extends Button

@export var items: Array[String]
@export var icons: Array[Texture2D]

var current_item: String
var current_icon: int

func _ready() -> void:
	if len(items) > 0:
		current_icon = 0
		current_item = items[0]
	
func ChangeIcon(icon_num: int) -> void:
	icon = icons[icon_num]
	current_icon = icon_num

func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
func ChangeToNextItem() -> void:
	if len(items) > 0:
		var new_icon = (current_icon + 1) % len(icons)
		ChangeIcon(new_icon)
		ChangeItem(new_icon)
	
func ChangeToPreviousItem() -> void:
	if len(items) > 0:
		var new_icon = (current_icon - 1) % len(icons)
		ChangeIcon(new_icon)
		ChangeItem(new_icon)
