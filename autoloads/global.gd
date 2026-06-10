extends Node

signal on_create_block_text(unit : Node2D)
signal on_create_damage_text(unit : Node2D , hitbox : HitboxComponent)
signal on_upgrade_selected 
signal on_create_heal_text(unit : Node2D , heal : float)

const FLASH_MATERIAL = preload("uid://d3if2ah6hrkol")
const FLOATING_TEXT_SCENES = preload("uid://cw4nn1b3lyjka")

const COMMON_STYLE = preload("uid://dw7owmfoc5n3e")
const EPIC_STYLE = preload("uid://cb0a3xhvx2na0")
const LEGENDARY_STYLE = preload("uid://cmepvf1ww0jpo")
const RARE_STYLE = preload("uid://bprixxc3qmp52")


const UPGRADE_PROBABILITY_CONFIG = {
	"rare" : {"start_wave" : 2 , "base_multi" : 0.06},
	"epic" : {"start_wave" : 4 , "base_multi" : 0.02},
	"legendary" : {"start_wave" : 7 , "base_multi" : 0.005}
}

enum UpgradeTier {
	COMMON,
	RARE,
	EPIC,
	LEGENDARY 
}

var coins : int
var player : Player
var game_pause : bool = false

func get_harvesting_coins() -> void:
	coins += player.stats.harvesting

func get_chance_access(chance : float) -> bool:
	var random : float = randf_range(0 , 1)
	if random < chance:
		return true
	return false

func get_tier_style(tier: UpgradeTier) -> StyleBoxFlat:
	match tier:
		UpgradeTier.COMMON:
			return COMMON_STYLE
		UpgradeTier.RARE:
			return RARE_STYLE
		UpgradeTier.EPIC:
			return EPIC_STYLE
		_:
			return LEGENDARY_STYLE

func calculate_tier_probability(current_wave : int , config : Dictionary) -> Array[float]:
	##稀有度 随 波次 计算
	var commen_chance : float = 0.0
	var rare_chance : float = 0.0
	var epic_chance : float = 0.0
	var legendary_chance : float = 0.0
	
	#稀有物品概率从第二波开始以6%增长
	if current_wave >= config.rare.start_wave:
		rare_chance = min(1.0 , (current_wave - 1) * config.rare.base_multi)
		
	#史诗物品概率从第四波开始以2%增长
	if current_wave >= config.epic.start_wave:
		epic_chance = min(1.0 , (current_wave - 3) * config.epic.base_multi)
		
	#传说物品概率从第七波开始以0.5%增长
	if current_wave >= config.legendary.start_wave:
		legendary_chance = min(1.0 , (current_wave - 6) * config.legendary.base_multi)
	
	#幸运对于高级物品概率的提升
	var luck_factor : float = 1.0 + (Global.player.stats.luck / 100)
	rare_chance *= luck_factor
	epic_chance *= luck_factor
	legendary_chance *= luck_factor
	
	#概率标准化处理
	var total_non_commen_chances : float = rare_chance + epic_chance + legendary_chance
	#使用缩放使得 稀有物品出现总概率 等比例 且 不超过1
	if total_non_commen_chances > 1.0:
		var scale_down : float = 1.0 / total_non_commen_chances
		rare_chance *= scale_down
		epic_chance *= scale_down
		legendary_chance *= scale_down
		total_non_commen_chances = 1.0
	
	#普通物品出现概率
	commen_chance = 1.0 - total_non_commen_chances
	
	#Debug
	print("Wave %d , Luck %.1f => Chances : C: %.2f R: %.2f E: %.2f L: %.2f" % 
	[current_wave , Global.player.stats.luck , commen_chance , rare_chance ,epic_chance , legendary_chance])
	
	return [
		max(0.0 , commen_chance),
		max(0.0 , rare_chance),
		max(0.0 , epic_chance),
		max(0.0 , legendary_chance),
	]

func select_item_for_offer(item_pool : Array , current_wave :int , config : Dictionary) -> Array:
	var tier_chances := calculate_tier_probability(current_wave , config)

	var legendary_limit := tier_chances[3]
	var epic_limit := legendary_limit + tier_chances[2]
	var rare_limit := epic_limit + tier_chances[1]
	
	var offered_items : Array = []
	while offered_items.size() < 4:
		##在可选列表数小于四时
		
		#随机0.0~1.0
		var roll := randf()
		#指定随机等级
		var chosen_tier_index := 0
		if roll < legendary_limit:
			chosen_tier_index = 3
		elif roll < epic_limit:
			chosen_tier_index = 2
		elif roll < rare_limit:
			chosen_tier_index = 1
		
		#预存储
		var potential_items : Array = []
		var current_search_item_index := chosen_tier_index
		
		#从数据库中筛选出有效类
		while potential_items.is_empty() and chosen_tier_index >= 0:
			potential_items = item_pool.filter(func(item : ItemBase): return item.item_tier == current_search_item_index)
			
			if potential_items.is_empty():
				current_search_item_index -= 1
			else:
				break
		
		#从有效类中随机选取，并且去重
		if not potential_items.is_empty():
			var selected_item = potential_items.pick_random() 
			
			if not offered_items.has(selected_item):
				offered_items.append(selected_item)
	
	return offered_items
