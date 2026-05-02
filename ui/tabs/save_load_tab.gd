class_name SaveLoadTab
extends CanvasLayer


func SaveButtonPressed() -> void:
	SaveLoadManager.SaveData()


func LoadButtonPressed() -> void:
	SaveLoadManager.LoadData()
