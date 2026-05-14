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
