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
	var price_per_unit = BaseSellPriceDictionary.price_dictionary[item]
	return price_per_unit * amount

func DecideSellPrice(item: String, amount: int) -> int:
	var price_per_unit = BaseSellPriceDictionary.price_dictionary[item]
	return price_per_unit * amount
