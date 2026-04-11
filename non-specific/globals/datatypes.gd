extends Node

var not_saveable: bool = true

enum Equipments {
	NONE,
	HOE,
	AXE,
	WATERING_CAN
}

enum Seeds {
	NONE,
	WHEAT,
	POTATO,
	LETTUCE
}

enum Seasons {
	SPRING,
	SUMMER,
	AUTUMN,
	WINTER
}

enum ItemTypes {
	NONE,
	PROCESSED_GOOD,
	EQUIPMENT,
	SEED,
	BUILDING,
	RAW_RESOURCE
}
