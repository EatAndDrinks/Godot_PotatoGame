extends Panel
class_name UpGradePanel

const UPGRADE_CARD_SCENE = preload("uid://c8p60ersgyl7d")

@export var upgrade_list : Array[ItemUpgrade]

@onready var item_container: HBoxContainer = %ItemContainer

func _ready() -> void:
	load_upgrades()

func load_upgrades() -> void:
	for child in item_container.get_children():
		child.queue_free()
	
	for i in 4:
		var random_upg : ItemUpgrade = upgrade_list.pick_random()
		var card_instance : UpgradeCard = UPGRADE_CARD_SCENE.instantiate()
		item_container.add_child(card_instance)
		card_instance.item_data = random_upg
