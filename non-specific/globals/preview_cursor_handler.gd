extends Node

# Cannot be saved, must have all data removed from cursor before saving occurs, or else items
# in cursor will be lost
var not_saveable: bool = true

var held_data: Dictionary
var data_preview_cursor: PreviewCursor
var cursor_packed_scene: PackedScene


# Function Information
# Use - Interface Use [Cursor Use]
# Does - Initialises the data within this script needed to create and use a cursor
func _ready() -> void:
	var cursor_data = Database.database["preview_cursor"] as PreviewCursorData
	cursor_packed_scene = cursor_data.cursor_scene


# Function Information
# Use - Interface Use [Cursor Use]
# Does - Moves the cursor showcasing the stored items to the player's mouse position within
#		the game screen
func _process(_delta: float) -> void:
	if data_preview_cursor != null:
		var offset = data_preview_cursor.size.x / 2
		data_preview_cursor.global_position = get_viewport().get_mouse_position() - Vector2(offset, offset)


# Function Information
# Use - Interface Use [Cursor Use]
# Does - Alows an interface handler to create a new cursor supplied with an item and amount to
#		then be nevigated and controlled for use of exchanging items between or within interfaces
func CreatePreviewCursor(preview_texture: Texture2D, data_to_hold: Dictionary) -> void:
	data_preview_cursor = cursor_packed_scene.instantiate()
	WorldComponentData.interface_ui.add_child(data_preview_cursor)
	data_preview_cursor.icon.texture = preview_texture
	
	if data_to_hold.has("amount") and data_to_hold["amount"] > 1:
		data_preview_cursor.amount_label.text = "x" + str(data_to_hold["amount"])
	if data_to_hold.has("price"):
		data_preview_cursor.price_label.text = GlobalData.currency_symbol + str(data_to_hold["price"])
	if not data_to_hold.has("source"):
		print("Error setting data to hold for cursor, no source.")
	held_data = data_to_hold


# Function Information
# Use - Interface Use [Cursor Use]
# Does - Deletes the stored data and current node used as the cursor
func RemovePreviewCursor() -> void:
	data_preview_cursor.queue_free()
	held_data["source"].has_item_in_cursor = false
	held_data.clear()


# Function Information
# Use - Interface Use [Cursor Use]
# Does - Allows an interface handler to take/remove items from the cursor and then have the logic
#		of formatting and removal of the cursor be controlled here
func ReduceAmountOfItemInCursor(amount: int) -> void:
	if not held_data.has("amount"):
		print("Error, cannot take from cursor, it does not have any amount data.")
		return
	if held_data["amount"] < amount:
		print("Error, cannot take " + str(amount) + " of item from cursor.")
		return
	
	held_data["amount"] -= amount
	# Update amount label
	if held_data["amount"] > 1:
		data_preview_cursor.amount_label.text = "x" + str(held_data["amount"])
	else:
		data_preview_cursor.amount_label.text = ""
	
	# No items left in cursor
	if held_data["amount"] == 0:
		RemovePreviewCursor()


# Function Information
# Use - Interface Use [Cursor Use]
# Does - Allows an interface handler to add items to the cursor and then have the logic of 
#		formatting of the cursor be controlled here
func IncreaseAmountOfItemInCursor(amount: int) -> void:
	if not held_data.has("amount"):
		print("Error, cannot add to cursor, it does not have any amount data.")
		return
	
	held_data["amount"] += amount
	# Update amount label
	data_preview_cursor.amount_label.text = "x" + str(held_data["amount"])


# Function Information
# Use - Interface Use [Cursor Use]
# Does - Allows interface handlers to be able to know if there is enough items stored in the 
#		cursor to take from
func CanTakeAmountFromCursor(amount: int) -> bool:
	if not held_data.has("amount") or held_data["amount"] < amount:
		return false
	return true
