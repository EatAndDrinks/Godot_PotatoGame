extends ItemBase
class_name ItemWeapon

enum WeaponType {
	FIGHT,
	SHOOT
}

@export var typr : WeaponType
@export var scene : PackedScene
@export var stats : WeaponStats
@export var upgrade_to : ItemWeapon

func get_description() -> String:
	##获取物品描述信息
	return "[code]Damage: [color=green]%s[/color]\nCooldown: [color=green]%s[/color]\nRange: [color=green]%s[/color]\nCritical: [color=green]%s%%[/color][/code]" % [stats.damage , stats.cooldown , stats.max_shoot_distance , stats.crit_chance * 100]
