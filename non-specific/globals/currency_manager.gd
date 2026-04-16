extends Node

var current_money: int = 0


func GainMoney(amount: int) -> void:
	current_money += amount


func ReduceMoney(amount: int) -> void:
	current_money -= amount


func CanSpendMoney(amount: int) -> bool:
	if amount <= current_money:
		return true
	else:
		return false


func DecideBuyPrice(item: String, amount: int) -> int:
	var price_per_unit = Database.database[item].base_sell_price
	return price_per_unit * amount


func DecideSellPrice(item: String, amount: int) -> int:
	var price_per_unit = Database.database[item].base_sell_price
	return price_per_unit * amount


func GetSaveData() -> Dictionary:
	var save_data = {
		"current_money": current_money
	}
	return save_data


func ApplyLoadedData(loaded_save_data: Dictionary) -> void:
	var applied = ["current_money"]	
	SaveLoadManager.CheckLoadedDataIsValid(applied, loaded_save_data.keys(), self)
	
	if loaded_save_data.has("current_money"): current_money = loaded_save_data["current_money"]
