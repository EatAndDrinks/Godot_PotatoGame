extends Panel
class_name UpGradePanel

const UPGRADE_CARD_SCENE = preload("uid://c8p60ersgyl7d")

@export var upgrade_list : Array[ItemUpgrade]

@onready var item_container: HBoxContainer = %ItemContainer



func load_upgrades(current_wave : int) -> void:
	for child in item_container.get_children():
		child.queue_free()
	
	var config := Global.UPGRADE_PROBABILITY_CONFIG
	var selected_upgrades := Global.select_item_for_offer(upgrade_list , current_wave , config)
	
	for random_upg : ItemUpgrade in selected_upgrades:
		var card_instance : UpgradeCard = UPGRADE_CARD_SCENE.instantiate()
		item_container.add_child(card_instance)
		card_instance.item_data = random_upg
