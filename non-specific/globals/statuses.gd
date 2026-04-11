extends Node

var not_saveable: bool = true

var can_save: bool = true
var can_load: bool = true

func ToggleSaveLoad(mode: String) -> void:
	if mode == "unlock":
		can_save = true
		can_load = true
	elif mode == "lock":
		can_save = false
		can_load = false
	else:
		print("Invalid input into toggle save load method.")
