class_name ShopSlot
extends InterfaceSlot

var price: int
@export var price_label: Label

func SetItem(given_name: String) -> void:
	super(given_name)
	UpdatePriceLabel()

func RemoveItem() -> void:
	super()
	price_label.text = ""
	
func AssignAmountLabel() -> void:
	amount = slot_item_assignment_component.current_contents[item_name]
	super()

func UpdatePriceLabel() -> void:
	price = CurrencyManager.DecideSellPrice(item_name, 1)
	price_label.text = str(GlobalData.currency_symbol) + str(price)
	
@warning_ignore("unused_parameter")
func _drop_data(at_position, data) -> void:
	var from_slot = data["from"]
	
	if interface != from_slot.interface and interface.being_used_in_interface_interaction:
		data["to"] = self
		interface.full_stack_movement.emit(data)
	
	# Return from slot to previous look
	from_slot.RemoveFocusFromSlot()
