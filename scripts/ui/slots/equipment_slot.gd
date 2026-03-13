class_name EquipmentSlot
extends Slot

@export var items: Array[String]
@export var icon: TextureRect
@export var default_item: String

var icon_textures: Array[Texture2D]
var current_item: String
var current_icon: int

func _ready() -> void:
	for item_name in items:
		icon_textures.append(NameTextureDictionary.texture_dictionary.get(item_name))
		
	if len(items) > 0:
		current_icon = 0
		current_item = items[0]
		
		icon.texture = icon_textures[current_icon]
	
func ChangeIcon(icon_num: int) -> void:
	icon.texture = icon_textures[icon_num]
	current_icon = icon_num

func ChangeItem(item_num: int) -> void:
	current_item = items[item_num]
	
func ChangeToNextItem() -> void:
	if len(items) > 0:
		var new_icon = (current_icon + 1) % len(icon_textures)
		ChangeIcon(new_icon)
		ChangeItem(new_icon)
	
func ChangeToPreviousItem() -> void:
	if len(items) > 0:
		var new_icon = (current_icon - 1) % len(icon_textures)
		ChangeIcon(new_icon)
		ChangeItem(new_icon)
		
func UnequipSlot() -> void:
	pass
	
func EquipSlot() -> void:
	pass
